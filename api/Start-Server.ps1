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

            $url = $request.Url

            switch ($url.AbsolutePath) {
                "/tracks" {
                    $json = Get-Content "$PSScriptRoot/json/tracks.json" | ConvertFrom-Json
                    $filter =  if ($url.Query) {
                        $sb = $(foreach ($pair in $url.Query.Substring(1) -split '&') {
                            $k, $v = $pair -split "="
                            "`$_.{$k} -eq '$v'"
                        }) -join " -and "
                        [scriptblock]::Create($sb)
                    } else { {$true} }

                    $items = @($json | Where-Object $filter)
                    $filteredJson =   ConvertTo-Json $items
                    $response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes($filteredJson), 0, [System.Text.Encoding]::UTF8.GetByteCount($filteredJson))
                    $response.StatusCode = 200 # ok
                }
                "/ratings" {
                    $json = Get-Content "$PSScriptRoot/json/ratings.json" | ConvertFrom-Json
                    $filter =  if ($url.Query) {
                        $sb = $(foreach ($pair in $url.Query.Substring(1) -split '&') {
                            $k, $v = $pair -split "="
                            "`$_.{$k} -eq '$v'"
                        }) -join " -and "
                        [scriptblock]::Create($sb)
                    } else { {$true} }

                    $items = @($json | Where-Object $filter)
                    $filteredJson =   ConvertTo-Json $items
                    $response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes($filteredJson), 0, [System.Text.Encoding]::UTF8.GetByteCount($filteredJson))
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

Start-Server