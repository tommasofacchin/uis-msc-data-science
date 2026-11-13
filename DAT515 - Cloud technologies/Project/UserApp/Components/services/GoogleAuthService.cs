using System.Net;
using System.Net.Sockets;
using System.Text;

namespace MyBlazorApp.Services;

public class GoogleAuthService
{
    private readonly HttpClient _http;

    public GoogleAuthService(HttpClient http) => _http = http;

    public async Task<string?> SignInAsync(CancellationToken ct = default)
    {
        var port = GetFreePort();
        var redirect = $"http://localhost:{port}/";

        using var listener = new HttpListener();
        listener.Prefixes.Add(redirect);
        listener.Start();

        var loginUrl = new Uri(_http.BaseAddress!, $"/auth/google?returnUrl={Uri.EscapeDataString(redirect)}");
        await Launcher.OpenAsync(loginUrl);

        using var cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
        cts.CancelAfter(TimeSpan.FromMinutes(2));
        using var registration = cts.Token.Register(listener.Stop);

        try
        {
            while (true)
            {
                var context = await listener.GetContextAsync();
                var token = context.Request.QueryString["token"];

                var html = string.IsNullOrEmpty(token)
                    ? "<html><body>Waiting for sign-in...</body></html>"
                    : "<html><body><h3>Signed in. You can close this tab and return to the app.</h3></body></html>";
                var bytes = Encoding.UTF8.GetBytes(html);
                context.Response.ContentType = "text/html; charset=utf-8";
                context.Response.ContentLength64 = bytes.Length;
                await context.Response.OutputStream.WriteAsync(bytes, cts.Token);
                context.Response.Close();

                if (!string.IsNullOrEmpty(token))
                    return token;
            }
        }
        catch (Exception) when (cts.IsCancellationRequested)
        {
            return null;
        }
    }

    private static int GetFreePort()
    {
        var l = new TcpListener(IPAddress.Loopback, 0);
        l.Start();
        var port = ((IPEndPoint)l.LocalEndpoint).Port;
        l.Stop();
        return port;
    }
}
