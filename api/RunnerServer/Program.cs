using Microsoft.Extensions.FileProviders;


namespace RunnerServer;

public static class Program {

    public static void Main(string[] args) {

        var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();

        app.MapGet("/", () => "Hello PSConfEU!");

        app.MapGet("/tracks", () =>
        {
            var json = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "json", "tracks.json"));
            return Results.Text(json, contentType: "application/json");
        });

        app.MapGet("/ratings", () =>
        {
            var json = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "json", "ratings.json"));
            return Results.Text(json, contentType: "application/json");
        });

        app.Run();
    } 
}