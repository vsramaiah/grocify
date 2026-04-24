$ErrorActionPreference = "Stop"

$port = 8080

if (Test-Path (Join-Path $PSScriptRoot "grocify-gsheetv3.0-Codex.html") -PathType Leaf) {
  $root = $PSScriptRoot
} elseif (Test-Path (Join-Path $PSScriptRoot "Grocify\\grocify-gsheetv3.0-Codex.html") -PathType Leaf) {
  $root = Join-Path $PSScriptRoot "Grocify"
} else {
  throw "Could not find grocify-gsheetv3.0-Codex.html relative to $PSScriptRoot"
}

function Get-ContentType {
  param([string]$Path)

  switch ([System.IO.Path]::GetExtension($Path).ToLowerInvariant()) {
    ".html" { "text/html; charset=utf-8" }
    ".js" { "application/javascript; charset=utf-8" }
    ".json" { "application/json; charset=utf-8" }
    ".css" { "text/css; charset=utf-8" }
    ".svg" { "image/svg+xml" }
    ".png" { "image/png" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".ico" { "image/x-icon" }
    default { "application/octet-stream" }
  }
}

function Get-LocalIPv4Address {
  $candidates = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
    Where-Object {
      $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork -and
      -not $_.IPAddressToString.StartsWith("127.")
    } |
    Select-Object -ExpandProperty IPAddressToString

  return $candidates | Select-Object -First 1
}

function Send-Response {
  param(
    [System.Net.Sockets.NetworkStream]$Stream,
    [int]$StatusCode,
    [string]$StatusText,
    [byte[]]$Body,
    [string]$ContentType = "text/plain; charset=utf-8"
  )

  $headers = @(
    "HTTP/1.1 $StatusCode $StatusText",
    "Content-Type: $ContentType",
    "Content-Length: $($Body.Length)",
    "Cache-Control: no-cache, no-store, must-revalidate",
    "Connection: close",
    ""
  ) -join "`r`n"

  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headers + "`r`n")
  $Stream.Write($headerBytes, 0, $headerBytes.Length)
  $Stream.Write($Body, 0, $Body.Length)
}

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
$listener.Start()

$localIp = Get-LocalIPv4Address

Write-Host "Grocify server running."
Write-Host "Serving from: $root"
Write-Host "This PC: http://localhost:$port/grocify-gsheetv3.0-Codex.html"
if ($localIp) {
  Write-Host "Mobile: http://$localIp`:$port/grocify-gsheetv3.0-Codex.html"
  Write-Host "Make sure phone and PC are on the same Wi-Fi."
}
Write-Host "Press Ctrl+C to stop."

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()

    try {
      $stream = $client.GetStream()
      $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
      $requestLine = $reader.ReadLine()

      while ($reader.Peek() -ge 0) {
        $line = $reader.ReadLine()
        if ([string]::IsNullOrWhiteSpace($line)) { break }
      }

      if ([string]::IsNullOrWhiteSpace($requestLine)) {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Bad request")
        Send-Response -Stream $stream -StatusCode 400 -StatusText "Bad Request" -Body $body
        continue
      }

      $parts = $requestLine.Split(" ")
      if ($parts.Length -lt 2 -or $parts[0] -ne "GET") {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Method not allowed")
        Send-Response -Stream $stream -StatusCode 405 -StatusText "Method Not Allowed" -Body $body
        continue
      }

      $requestPath = [System.Uri]::UnescapeDataString($parts[1].TrimStart("/"))
      if ([string]::IsNullOrWhiteSpace($requestPath)) {
        $requestPath = "grocify-gsheetv3.0-Codex.html"
      }

      $requestPath = $requestPath.Split("?")[0]
      $fullPath = [System.IO.Path]::GetFullPath((Join-Path $root $requestPath))
      $rootPath = [System.IO.Path]::GetFullPath($root)

      if (-not $fullPath.StartsWith($rootPath, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $fullPath -PathType Leaf)) {
        $body = [System.Text.Encoding]::UTF8.GetBytes("Not found")
        Send-Response -Stream $stream -StatusCode 404 -StatusText "Not Found" -Body $body
        continue
      }

      $bytes = [System.IO.File]::ReadAllBytes($fullPath)
      Send-Response -Stream $stream -StatusCode 200 -StatusText "OK" -Body $bytes -ContentType (Get-ContentType -Path $fullPath)
    }
    finally {
      if ($reader) { $reader.Dispose() }
      if ($stream) { $stream.Dispose() }
      $client.Close()
    }
  }
}
finally {
  $listener.Stop()
}
