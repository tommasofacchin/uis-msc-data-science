namespace Classes.JWTToken;

public class FileRecord
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid OwnerId { get; set; }
    public string ObjectKey { get; set; } = "";
    public string OriginalName { get; set; } = "";
    public long Size { get; set; }
    public string ContentType { get; set; } = "";
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
}
