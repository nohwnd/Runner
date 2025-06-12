
function Start-Server {
    $listener = [System.Net.HttpListener]::new()
    try {
        $endpoint = "http://localhost:5000/"
        $listener.Prefixes.Add($endpoint)
        $listener.Start()

        Write-Host "Listening on: $endpoint"

        while ($true) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response

            $response.ContentType = "application/json"

            if ($request.HttpMethod -ne "GET") {
                $response.StatusCode = 404 # not found
            }

            switch ($request.Url.AbsolutePath) {
                "/tracks" {
                    $json = [System.IO.File]::ReadAllBytes("$PSScriptRoot/json/tracks.json")
                    $response.OutputStream.Write($json, 0, $json.Length)
                    $response.StatusCode = 200 # ok
                }
                "/ratings" {
                    $json = [System.IO.File]::ReadAllBytes("$PSScriptRoot/json/ratings.json")
                    $response.OutputStream.Write($json, 0, $json.Length)
                    $response.StatusCode = 200 # ok
                }
                default {
                    $response.StatusCode = 404 # not found
                }
            }

            $response.Close()
        }
    }
    finally {
        $listener.Close()
    }
}