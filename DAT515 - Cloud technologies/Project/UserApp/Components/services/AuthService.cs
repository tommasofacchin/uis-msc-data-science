using System.Text.Json;

namespace MyBlazorApp.Services;

public class AuthService
{
    private const string Key = "token";

    public event Action? SessionExpired;

    public async Task SaveTokenAsync(string token)
    {
        try { await SecureStorage.SetAsync(Key, token); }
        catch (Exception) { Preferences.Set(Key, token); } // fallback when SecureStorage is unavailable
    }

    public async Task<string?> GetTokenAsync()
    {
        try
        {
            var t = await SecureStorage.GetAsync(Key);
            if (!string.IsNullOrEmpty(t)) return t;
        }
        catch (Exception) { }
        var p = Preferences.Get(Key, "");
        return string.IsNullOrEmpty(p) ? null : p;
    }

    public async Task<bool> IsLoggedInAsync() => !string.IsNullOrEmpty(await GetTokenAsync());

    public void Logout()
    {
        try { SecureStorage.Remove(Key); } catch (Exception) { }
        Preferences.Remove(Key);
    }

    // Called when the API rejects our token (expired or invalid).
    public void NotifySessionExpired()
    {
        Logout();
        SessionExpired?.Invoke();
    }

    // Reads the user name from the JWT payload (no signature check: display only).
    public async Task<string?> GetUserNameAsync()
    {
        var token = await GetTokenAsync();
        if (string.IsNullOrEmpty(token)) return null;

        try
        {
            var payload = token.Split('.')[1].Replace('-', '+').Replace('_', '/');
            payload = payload.PadRight(payload.Length + (4 - payload.Length % 4) % 4, '=');
            using var doc = JsonDocument.Parse(Convert.FromBase64String(payload));

            foreach (var name in new[]
            {
                "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name",
                "unique_name",
                "name"
            })
            {
                if (doc.RootElement.TryGetProperty(name, out var value))
                    return value.GetString();
            }
        }
        catch (Exception) { }
        return null;
    }
}
