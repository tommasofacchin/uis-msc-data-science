namespace Classes.JWTToken;
public class SystemUser
{
    public Guid Id {get; protected set;} = Guid.NewGuid();
    public string Name {get; set;} = "";

    public string PasswordHash {get; set;} = "";

    public Role Role{get; set;}
}
public enum Role
{
    User,
    Admin
}