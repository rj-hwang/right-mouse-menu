function testOk1 {
  param (
    [string]$Url
  )
    
  Write-Host "testOk$Url"
}

function MyTest2 {
  param (
    [string]$url,
    [string]$b,
    [string]$a = $null
  )

  Write-Output "URL: $url"
  Write-Output "Parameter b: $b"

  if ($a) {
    Write-Output "Parameter a: $a"
  }
}