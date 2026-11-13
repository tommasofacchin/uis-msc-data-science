
using Google.Apis.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Database;
using Classes.JWTToken;

namespace Controllers;

[ApiController]
[Route("auth")]
public class GoogleAuthController : ControllerBase
{
    private readonly UserDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly TokenService _tokenService;

    public GoogleAuthController(
        UserDbContext context,
        IConfiguration configuration,
        TokenService tokenService)
    {
        _context = context;
        _configuration = configuration;
        _tokenService = tokenService;
    }

    [HttpGet("google")]
    public IActionResult GoogleLogin([FromQuery] string? returnUrl)
    {
        var clientId = _configuration["Google:ClientId"]
            ?? throw new InvalidOperationException("Google ClientId missing");

        var callbackUrl = GetCallbackUrl();

        var state = Convert.ToBase64String(
            RandomNumberGenerator.GetBytes(32));

        // Store state in a secure, short-lived cookie.
        Response.Cookies.Append("oauth_state", state,
            new CookieOptions
            {
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Lax,
                MaxAge = TimeSpan.FromMinutes(5)
            });

        if (IsLoopbackUrl(returnUrl))
        {
            Response.Cookies.Append("oauth_return", returnUrl!,
                new CookieOptions
                {
                    HttpOnly = true,
                    Secure = Request.IsHttps,
                    SameSite = SameSiteMode.Lax,
                    MaxAge = TimeSpan.FromMinutes(5)
                });
        }

        var url =
            "https://accounts.google.com/o/oauth2/v2/auth" +
            "?client_id=" + Uri.EscapeDataString(clientId) +
            "&redirect_uri=" + Uri.EscapeDataString(callbackUrl) +
            "&response_type=code" +
            "&scope=" + Uri.EscapeDataString("openid email profile") +
            "&state=" + Uri.EscapeDataString(state);

        return Redirect(url);
    }

    [HttpGet("/signin-google")]
    public async Task<IActionResult> GoogleCallback(
        [FromQuery] string? code,
        [FromQuery] string? state,
        [FromQuery] string? error)
    {
        if (!string.IsNullOrEmpty(error))
            return Unauthorized("Google authentication failed.");

        var expectedState = Request.Cookies["oauth_state"];

        Response.Cookies.Delete("oauth_state");

        var returnUrl = Request.Cookies["oauth_return"];
        Response.Cookies.Delete("oauth_return");

        if (string.IsNullOrEmpty(state) ||
            string.IsNullOrEmpty(expectedState) ||
            state != expectedState)
        {
            return BadRequest("Invalid OAuth state.");
        }

        if (string.IsNullOrEmpty(code))
            return BadRequest("Missing authorization code.");

        var clientId = _configuration["Google:ClientId"]
            ?? throw new InvalidOperationException("Google ClientId missing");

        var clientSecret = _configuration["Google:ClientSecret"]
            ?? throw new InvalidOperationException("Google ClientSecret missing");

        var callbackUrl = GetCallbackUrl();

        // Exchange authorization code for Google tokens.
        using var httpClient = new HttpClient();

        var tokenResponse = await httpClient.PostAsync(
            "https://oauth2.googleapis.com/token",
            new FormUrlEncodedContent(
                new Dictionary<string, string>
                {
                    ["code"] = code,
                    ["client_id"] = clientId,
                    ["client_secret"] = clientSecret,
                    ["redirect_uri"] = callbackUrl,
                    ["grant_type"] = "authorization_code"
                }));

        if (!tokenResponse.IsSuccessStatusCode)
            return Unauthorized("Google token exchange failed.");

        var tokenJson = await tokenResponse.Content.ReadAsStringAsync();

        using var json = JsonDocument.Parse(tokenJson);

        var idToken = json.RootElement
            .GetProperty("id_token")
            .GetString();

        if (string.IsNullOrEmpty(idToken))
            return Unauthorized("Google ID token missing.");

        // Validate Google's identity token.
        var payload = await GoogleJsonWebSignature.ValidateAsync(
            idToken,
            new GoogleJsonWebSignature.ValidationSettings
            {
                Audience = new[] { clientId }
            });

        if (string.IsNullOrEmpty(payload.Subject) ||
            string.IsNullOrEmpty(payload.Email))
        {
            return Unauthorized("Google account information missing.");
        }

        if (!payload.EmailVerified)
            return Unauthorized("Google email is not verified.");

        // Find or create application user.
        var email = payload.Email.Trim().ToLowerInvariant();

        var user = await _context.SystemUsers
            .FirstOrDefaultAsync(u => u.Name == email);

        if (user == null)
        {
            user = new SystemUser
            {
                Name = email,
                PasswordHash = "",
                Role = Role.User
            };

            _context.SystemUsers.Add(user);

            await _context.SaveChangesAsync();
        }

        // Issue YOUR application's JWT.
        var applicationToken = _tokenService.GenerateJWTToken(user);

        if (IsLoopbackUrl(returnUrl))
        {
            return Redirect($"{returnUrl}?token={Uri.EscapeDataString(applicationToken)}");
        }

        return Ok(new
        {
            message = "Google login succeeded.",
            token = applicationToken,
            user = new
            {
                user.Id,
                user.Name,
                role = user.Role.ToString()
            }
        });
    }

    private static bool IsLoopbackUrl(string? url) =>
        Uri.TryCreate(url, UriKind.Absolute, out var u)
        && u.Scheme == Uri.UriSchemeHttp
        && u.IsLoopback;


    private string GetCallbackUrl()
    {
        return "https://api.kamen.no/signin-google";
    }
}
