using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Classes.JWTToken;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace Api.Tests;

public class TokenServiceTests
{
    private const string Secret = "test-secret-test-secret-test-secret-123";

    private static TokenService MakeService() =>
        new(new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?> {
                ["ApplicationSettings:JWT_Secret"] = Secret })
            .Build());

    private static SystemUser MakeUser() => new() { Name = "a@b.com" };

    [Fact]
    public void Token_contains_user_id_and_name()
    {
        var user = MakeUser();
        var jwt = new JwtSecurityTokenHandler().ReadJwtToken(MakeService().GenerateJWTToken(user));

        Assert.Equal(user.Id.ToString(), jwt.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value);
        Assert.Equal("a@b.com", jwt.Claims.First(c => c.Type == ClaimTypes.Name).Value);
    }

    [Fact]
    public void Token_expires_in_about_30_days()
    {
        var jwt = new JwtSecurityTokenHandler().ReadJwtToken(MakeService().GenerateJWTToken(MakeUser()));
        var days = (jwt.ValidTo - DateTime.UtcNow).TotalDays;
        Assert.InRange(days, 29.9, 30.1);
    }

    [Fact]
    public void Token_is_signed_with_the_configured_secret()
    {
        var token = MakeService().GenerateJWTToken(MakeUser());
        var handler = new JwtSecurityTokenHandler();

        TokenValidationParameters Params(string key) => new() {
            ValidateIssuer = false, ValidateAudience = false,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key))
        };

        handler.ValidateToken(token, Params(Secret), out _); // ok
        Assert.ThrowsAny<SecurityTokenException>(() =>
            handler.ValidateToken(token, Params("another-secret-another-secret-12345"), out _));
    }
}
