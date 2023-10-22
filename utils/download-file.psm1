function DownloadFile {
  # [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$Url
  )
    
  Write-Host "1----------------$Url"
}
