namespace Controllers.Logincontroller;

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
[Route("/login")]
public class Userlogin : ControllerBase
{

    private readonly UserDbContext _context;
    private readonly TokenService _tokenService;
    public Userlogin(UserDbContext context, TokenService tokenService){
        _context = context;
        _tokenService = tokenService;
    }
    private readonly PasswordHasher<SystemUser> _passwordHasher = new();
    [HttpPost]

    public async Task<IActionResult> Login([FromBody] UserRequest request){
        if (string.IsNullOrWhiteSpace(request.email) ||
            string.IsNullOrWhiteSpace(request.password))
        {
            return BadRequest(new
            {
                message = "Email and password are required."
            });
        }
        

        string name = request.email.Trim();
        var user = await _context.SystemUsers.FirstOrDefaultAsync(u => u.Name == name);
        if (user == null)
        {
            return Unauthorized(new { message = "Email or Password is wrong" });
        }

        var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.password);
        if (result == PasswordVerificationResult.Failed)
        {
            return Unauthorized(new { message = "Email or Password is wrong" });
        }

        var token = _tokenService.GenerateJWTToken(user);
        return Ok(new{message="Login succeded", token});
        }
    

}