# �����ļ�
function downloadFile {
  # [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position=0)]
    [string]$url
    [Parameter(Mandatory = $false)]
    [string]$toFIle
  )
    
  Write-Host "url=$url"
}

downloadFile "aaaa"


# ���ú�����ָ�����в���
# MyTest2 "https://www.example.com" -a "value of a" -b "value of b"

# ���ú�����ָֻ������Ĳ��� b
# MyTest2 "https://www.example.com" -b "value of b"