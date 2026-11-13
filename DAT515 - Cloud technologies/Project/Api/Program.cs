
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Classes.JWTToken;
using Minio;
using Minio.DataModel.Args;
using Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.HttpOverrides;
using System.Security.Claims;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.Runtime;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.AddAuthorization();
builder.Services.AddDbContext<UserDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("UserDbConnection")
    ));
builder.Services.AddControllers();



var configuration = builder.Configuration;
builder.Services.AddAuthentication(cfg => {
    cfg.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    cfg.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    cfg.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(x => {
    x.RequireHttpsMetadata = false;
    x.SaveToken = false;
    x.TokenValidationParameters = new TokenValidationParameters {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8
            .GetBytes(configuration["ApplicationSettings:JWT_Secret"])
        ),
        ValidateIssuer = false,
        ValidateAudience = false,
        ClockSkew = TimeSpan.Zero
    };
});
builder.Services.AddSingleton<IAmazonS3>(_ => new AmazonS3Client(
    builder.Configuration["Garage:AccessKey"],
    builder.Configuration["Garage:SecretKey"],
    new AmazonS3Config
    {
        ServiceURL = "http://192.168.10.161:3900",
        ForcePathStyle = true,
        AuthenticationRegion = "garage",
        RequestChecksumCalculation = RequestChecksumCalculation.WHEN_REQUIRED,
        ResponseChecksumValidation = ResponseChecksumValidation.WHEN_REQUIRED
    }));

builder.Services.AddScoped<TokenService>();


var minioCfg = builder.Configuration.GetSection("Minio");
builder.Services.AddSingleton<IMinioClient>(_ => new MinioClient()
    .WithEndpoint(minioCfg["Endpoint"])
    .WithCredentials(minioCfg["AccessKey"], minioCfg["SecretKey"])
    .WithSSL(false)
    .Build());


var app = builder.Build();
var config = new AmazonS3Config
{
    ServiceURL = "http://192.168.10.161:3900",
    ForcePathStyle = true,
    AuthenticationRegion = "garage"
};
app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders =
        ForwardedHeaders.XForwardedFor |
        ForwardedHeaders.XForwardedProto
});
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<UserDbContext>();

    await db.Database.EnsureCreatedAsync();

    await db.Database.ExecuteSqlRawAsync("""
    CREATE TABLE IF NOT EXISTS "Files" (
        "Id" uuid PRIMARY KEY,
        "OwnerId" uuid NOT NULL,
        "ObjectKey" text NOT NULL,
        "OriginalName" text NOT NULL,
        "Size" bigint NOT NULL,
        "ContentType" text NOT NULL,
        "UploadedAt" timestamp with time zone NOT NULL
    );
    CREATE INDEX IF NOT EXISTS "IX_Files_OwnerId" ON "Files" ("OwnerId");
    CREATE UNIQUE INDEX IF NOT EXISTS "IX_Files_ObjectKey" ON "Files" ("ObjectKey");
    """);

}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();







app.MapGet("/", () =>
{
    string message = "Hello world 1.3";
    return message;
}).WithName("Index");


// Garage
static string UserId(ClaimsPrincipal u) =>
    u.FindFirstValue(ClaimTypes.NameIdentifier)
    ?? u.FindFirstValue("nameid")
    ?? u.FindFirstValue("sub")
    ?? throw new UnauthorizedAccessException();

static Guid UserGuid(ClaimsPrincipal u) => Guid.Parse(UserId(u));

app.MapPost("/files", async (IFormFile file, ClaimsPrincipal user, IAmazonS3 client, UserDbContext db) =>
{
    var bucket = minioCfg["Bucket"]!;
    var owner = UserGuid(user);
    var originalName = Path.GetFileName(file.FileName);
    var objectName = $"{owner}/{Guid.NewGuid()}-{originalName}";

    await using var stream = file.OpenReadStream();
    await client.PutObjectAsync(new PutObjectRequest
    {
        BucketName = bucket,
        Key = objectName,
        InputStream = stream,
        ContentType = file.ContentType,
        Headers = { ContentLength = file.Length }
    });

    var record = new FileRecord
    {
        OwnerId = owner,
        ObjectKey = objectName,
        OriginalName = originalName,
        Size = file.Length,
        ContentType = file.ContentType
    };
    db.Files.Add(record);
    await db.SaveChangesAsync();

    return Results.Ok(new { id = record.Id, objectName, size = file.Length });
})
.DisableAntiforgery()
.RequireAuthorization();

app.MapGet("/files", async (ClaimsPrincipal user, UserDbContext db) =>
{
    var owner = UserGuid(user);
    var files = await db.Files
        .Where(f => f.OwnerId == owner)
        .OrderByDescending(f => f.UploadedAt)
        .Select(f => new FileDto(f.ObjectKey, f.OriginalName, f.Size, f.UploadedAt))
        .ToListAsync();

    return Results.Ok(files);
})
.RequireAuthorization();


app.MapGet("/files/download", async (string key, ClaimsPrincipal user, IAmazonS3 client, UserDbContext db) =>
{
    var owner = UserGuid(user);
    var record = await db.Files.FirstOrDefaultAsync(f => f.ObjectKey == key && f.OwnerId == owner);
    if (record is null)
        return Results.NotFound();

    using var response = await client.GetObjectAsync(minioCfg["Bucket"]!, record.ObjectKey);
    var ms = new MemoryStream();
    await response.ResponseStream.CopyToAsync(ms);
    ms.Position = 0;

    return Results.File(ms,
        string.IsNullOrEmpty(record.ContentType) ? "application/octet-stream" : record.ContentType,
        record.OriginalName);
})
.RequireAuthorization();

app.MapDelete("/files", async (string key, ClaimsPrincipal user, IAmazonS3 client, UserDbContext db) =>
{
    var owner = UserGuid(user);
    var record = await db.Files.FirstOrDefaultAsync(f => f.ObjectKey == key && f.OwnerId == owner);
    if (record is null)
        return Results.NotFound();

    await client.DeleteObjectAsync(minioCfg["Bucket"]!, record.ObjectKey);

    db.Files.Remove(record);
    await db.SaveChangesAsync();

    return Results.NoContent();
})
.RequireAuthorization();


app.Run();
record FileDto(string Key, string Name, long Size, DateTime? LastModified);


