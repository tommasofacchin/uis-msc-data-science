namespace Controllers.Registrationcontroller;

using Classes.JWTToken;
using Microsoft.AspNetCore.Mvc;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Database;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
[ApiController]
[Route("/register")]
public class UserController : ControllerBase
{
    private readonly UserDbContext _context;
    private readonly TokenService _tokenService;
    public UserController(UserDbContext context, TokenService tokenService){
        _context = context;
        _tokenService = tokenService;
    }
    private readonly PasswordHasher<SystemUser> _passwordHasher = new();

    bool IsValidEmail(string strIn)
    {
        // Return true if strIn is in valid email format.
        return Regex.IsMatch(strIn, @"^([\w\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
    }
    [HttpPost]
    public async Task<IActionResult> CreateUser([FromBody] UserRequest request)
    {
        if (string.IsNullOrEmpty(request.password))
        {
            return BadRequest(new { message = "Password is required." });
        }
        string name = request.email;

        if (IsValidEmail(name))
        {
            if (await _context.SystemUsers.AnyAsync(u => u.Name == name))
                return Conflict(new { message = "Email already registered." });

            var user = new SystemUser(){
            Name = name,
        };
        user.PasswordHash = _passwordHasher.HashPassword(
            user,
            request.password
        );
        _context.SystemUsers.Add(user);

        await _context.SaveChangesAsync();
        var token = _tokenService.GenerateJWTToken(user);
        return Ok(new { message = "User created successfully.", token});
        }
        else
        {
            return BadRequest(new {message = "Invalid Email"});
        }

    }
}
