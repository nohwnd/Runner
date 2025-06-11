dotnet publish "RunnerServer.csproj" --self-contained -r win-x64
dotnet publish "RunnerServer.csproj" --self-contained -r win-arm64
dotnet publish "RunnerServer.csproj" --self-contained -r linux-x64
dotnet publish "RunnerServer.csproj" --self-contained -r linux-arm64
dotnet publish "RunnerServer.csproj" --self-contained -r osx-x64
dotnet publish "RunnerServer.csproj" --self-contained -r osx-arm64

Then run RunnerServer\bin\Debug\net8.0\RunnerServer.dll