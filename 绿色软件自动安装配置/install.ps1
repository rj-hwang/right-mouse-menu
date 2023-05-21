# 绿色软件自动安装配置的 PowerShell 脚本
# 本文件编码为 ANSI 而非 UTF-8

# 设置用户级别的环境变量

## 读取环境变量配置文件 `.env`
$envList = Get-Content -Path ".env"

Write-Output "设置用户级别的环境变量："
$envList | ForEach-Object {
  # 忽略注释行和空行
  if ($_ -notmatch "^#" -and $_.Length -gt 0) {
    $name, $value = $_ -split "="
    $name = $name.Trim()
    $value = $value.Trim()
    Write-Host "  $name=$value"

    # 设置环境变量
    if ($name -eq "Path") {
      $path = [Environment]::GetEnvironmentVariable('Path', 'User')
      Write-Host "  Original Path=$path"
    }
    [Environment]::SetEnvironmentVariable($name, $value, "User")
  }
}
