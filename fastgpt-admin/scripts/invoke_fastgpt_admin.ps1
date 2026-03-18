param(
  [Parameter(Mandatory = $true)]
  [string]$Method,

  [Parameter(Mandatory = $true)]
  [string]$Url,

  [string]$Cookie = "",

  [string]$Authorization = "",

  [string]$BodyFile = ""
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$uri = [System.Uri]$Url
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

if ($Cookie) {
  foreach ($part in ($Cookie -split ';')) {
    $trimmed = $part.Trim()
    if (-not $trimmed) {
      continue
    }

    $segments = $trimmed -split '=', 2
    if ($segments.Length -ne 2) {
      continue
    }

    try {
      $cookieObj = New-Object System.Net.Cookie($segments[0], $segments[1], '/', $uri.Host)
      $session.Cookies.Add($cookieObj)
    } catch {
      continue
    }
  }
}

$headers = @{
  Accept = 'application/json'
}

if ($Authorization) {
  $headers['Authorization'] = $Authorization
}

if ($BodyFile -and (Test-Path $BodyFile)) {
  $body = Get-Content -Path $BodyFile -Raw -Encoding UTF8
  $resp = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers -WebSession $session -ContentType 'application/json' -Body $body
} else {
  $resp = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers -WebSession $session
}

$resp | ConvertTo-Json -Depth 20
