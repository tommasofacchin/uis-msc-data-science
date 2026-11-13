using Classes.JWTToken;
using Controllers.Registrationcontroller;
using Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Api.Tests;

public class RegistrationTests
{
    private static (UserController, UserDbContext) Make()
    {
        var db = new UserDbContext(new DbContextOptionsBuilder<UserDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
        var config = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?> {
                ["ApplicationSettings:JWT_Secret"] = "test-secret-test-secret-test-secret-123" })
            .Build();
        return (new UserController(db, new TokenService(config)), db);
    }

    [Fact]
    public async Task Empty_password_returns_400()
    {
        var (c, _) = Make();
        var r = await c.CreateUser(new UserRequest { email = "a@b.com", password = "" });
        Assert.IsType<BadRequestObjectResult>(r);
    }

    [Fact]
    public async Task Invalid_email_returns_400()
    {
        var (c, _) = Make();
        var r = await c.CreateUser(new UserRequest { email = "not-an-email", password = "pw12345" });
        Assert.IsType<BadRequestObjectResult>(r);
    }

    [Fact]
    public async Task Duplicate_email_returns_409()
    {
        var (c, _) = Make();
        var req = new UserRequest { email = "a@b.com", password = "pw12345" };
        await c.CreateUser(req);
        Assert.IsType<ConflictObjectResult>(await c.CreateUser(req));
    }

    [Fact]
    public async Task Valid_registration_returns_ok_and_stores_hashed_password()
    {
        var (c, db) = Make();
        var r = await c.CreateUser(new UserRequest { email = "a@b.com", password = "pw12345" });

        Assert.IsType<OkObjectResult>(r);
        var user = await db.SystemUsers.SingleAsync();
        Assert.NotEqual("pw12345", user.PasswordHash);
        Assert.False(string.IsNullOrEmpty(user.PasswordHash));
    }
}
