using System.Net;
using System.Net.Http.Headers;

namespace MyBlazorApp.Services;

public class AuthHeaderHandler : DelegatingHandler
{
    private readonly AuthService _auth;

    public AuthHeaderHandler(AuthService auth) => _auth = auth;

    protected override async Task<HttpResponseMessage> SendAsync(
        HttpRequestMessage request, CancellationToken ct)
    {
        var token = await _auth.GetTokenAsync();
        var hadToken = !string.IsNullOrEmpty(token);
        if (hadToken)
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var response = await base.SendAsync(request, ct);

        // The server rejected our token: clear it and send the user back to the login page.
        if (hadToken && response.StatusCode == HttpStatusCode.Unauthorized)
            _auth.NotifySessionExpired();

        return response;
    }
}
