using Microsoft.EntityFrameworkCore;
using Classes.JWTToken;

namespace Database;

public class UserDbContext : DbContext
{
    public UserDbContext(DbContextOptions<UserDbContext> options)
        : base(options)
    {

    }

    public DbSet<SystemUser> SystemUsers { get; set; }

    public DbSet<FileRecord> Files { get; set; }

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.Entity<FileRecord>().HasIndex(f => f.OwnerId);
        b.Entity<FileRecord>().HasIndex(f => f.ObjectKey).IsUnique();
    }


}