# 下载文件
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


# 调用函数并指定所有参数
# MyTest2 "https://www.example.com" -a "value of a" -b "value of b"

# 调用函数并只指定必须的参数 b
# MyTest2 "https://www.example.com" -b "value of b"