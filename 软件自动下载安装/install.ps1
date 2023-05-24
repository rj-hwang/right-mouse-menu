# 绿色软件自动安装配置的 PowerShell 脚本
# 本文件编码为 ANSI 而非 UTF-8
Write-Host $(Get-date) 开始

# 1. 设置用户级别的环境变量
## 读取环境变量配置文件 `.env`
# $envList = Get-Content -Path ".env"
# Write-Output "设置用户级别的环境变量："
# $envList | ForEach-Object {
#   # 忽略注释行和空行
#   if ($_ -notmatch "^#" -and $_.Length -gt 0) {
#     $name, $value = $_ -split "="
#     $name = $name.Trim()
#     $value = $value.Trim()
#     Write-Host "  $name=$value"

#     # 设置环境变量
#     if ($name -eq "Path") {
#       $path = [Environment]::GetEnvironmentVariable('Path', 'User')
#       Write-Host "  Original Path=$path"
#     }
#     [Environment]::SetEnvironmentVariable($name, $value, "User")
#   }
# }

# 2. 下载绿色软件
$toDir = "downloads"
if (!(Test-Path $toDir)) {
  New-Item -ItemType Directory -Path $toDir
}
## 读取要下载配置
$jsonString  = Get-Content -Path "cfg.json" -Raw
$cfg = ConvertFrom-Json -InputObject $jsonString
Write-Host "开始下载软件："
$cfg.items | ForEach-Object {
  $toFile = Join-Path $toDir $_.file
  if (!(Test-Path $toFile)) {
    Write-Host "  下载 $($_.name) $($_.size) Release on $($_.date)..."
    $url = $_.url
    try {
      # 下载文件
      Invoke-WebRequest $url -OutFile $toFile
      if ($_.PSObject.Properties.Name -contains 'sha512') {
        # 校验下载文件的 sha512 值是否匹配
        Write-Host "    下载完成，检测文件的 sha512 值..."
        $realSha = Get-FileHash $toFile -Algorithm SHA512
        if ($realSha.Hash -eq $($_.sha512).ToUpper()) {
          Write-Host "    下载成功，文件 sha512 值一致"
        } else {
          Write-Host "    下载成功，但文件 sha512 值错误"
          Write-Host "      expected sha512=$($_.sha512)"
          Write-Host "      actual   sha512=$($realSha.Hash)"
        }
      } elseif ($_.PSObject.Properties.Name -contains 'sha256') {
        # 校验下载文件的 sha256 值是否匹配
        Write-Host "    下载完成，检测文件的 sha256 值..."
        $realSha = Get-FileHash $toFile -Algorithm SHA256
        if ($realSha.Hash -eq $($_.sha256).ToUpper()) {
          Write-Host "    下载成功，文件 sha256 值一致"
        } else {
          Write-Host "    下载成功，但文件 sha256 值错误"
          Write-Host "      expected sha256=$($_.sha256)"
          Write-Host "      actual   sha256=$($realSha.Hash)"
        }
      } else {
        Write-Host "    下载成功"
      }
    } catch { 
      Write-Host "    下载失败"
      Write-Host "    url=$url"
      Write-Host "    error=$_"
      # 下载异常需要删除中途下载的文件
      if (Test-Path $toFile) {
        Remove-Item $toFile -Force
      }
    }
  } else {
    Write-Host "  已存在，忽略不重复下载 $($_.name) $($_.size) Release on $($_.date) to $toFile"
    if ($_.PSObject.Properties.Name -contains 'sha512') {
      # 校验下载文件的 sha512 值是否匹配
      Write-Host "    检测文件的 sha512 值..."
      $realSha = Get-FileHash $toFile -Algorithm SHA512
      if ($realSha.Hash -eq $($_.sha512).ToUpper()) {
        Write-Host "    文件 sha512 值一致"
      } else {
        Write-Host "    但文件 sha512 值错误"
        Write-Host "      expected sha512=$($_.sha512)"
        Write-Host "      actual   sha512=$($realSha.Hash)"
      }
    } elseif ($_.PSObject.Properties.Name -contains 'sha256') {
      # 校验下载文件的 sha256 值是否匹配
      Write-Host "    检测文件的 sha256 值..."
      $realSha = Get-FileHash $toFile -Algorithm SHA256
      if ($realSha.Hash -eq $($_.sha256).ToUpper()) {
        Write-Host "    文件 sha256 值一致"
      } else {
        Write-Host "    文件 sha256 值错误"
        Write-Host "      expected sha256=$($_.sha256)"
        Write-Host "      actual   sha256=$($realSha.Hash)"
      }
    }
  }
}

Write-Host $(Get-date) 结束