# ��ɫ����Զ���װ���õ� PowerShell �ű�
# ���ļ�����Ϊ ANSI ���� UTF-8
Write-Host $(Get-date) ��ʼ

# 1. �����û�����Ļ�������
## ��ȡ�������������ļ� `.env`
# $envList = Get-Content -Path ".env"
# Write-Output "�����û�����Ļ���������"
# $envList | ForEach-Object {
#   # ����ע���кͿ���
#   if ($_ -notmatch "^#" -and $_.Length -gt 0) {
#     $name, $value = $_ -split "="
#     $name = $name.Trim()
#     $value = $value.Trim()
#     Write-Host "  $name=$value"

#     # ���û�������
#     if ($name -eq "Path") {
#       $path = [Environment]::GetEnvironmentVariable('Path', 'User')
#       Write-Host "  Original Path=$path"
#     }
#     [Environment]::SetEnvironmentVariable($name, $value, "User")
#   }
# }

# 2. ������ɫ���
$toDir = "downloads"
if (!(Test-Path $toDir)) {
  New-Item -ItemType Directory -Path $toDir
}
## ��ȡҪ��������
$jsonString  = Get-Content -Path "cfg.json" -Raw
$cfg = ConvertFrom-Json -InputObject $jsonString
Write-Host "��ʼ���������"
$cfg.items | ForEach-Object {
  $toFile = Join-Path $toDir $_.file
  if (!(Test-Path $toFile)) {
    Write-Host "  ���� $($_.name) $($_.size) Release on $($_.date)..."
    $url = $_.url
    try {
      # �����ļ�
      Invoke-WebRequest $url -OutFile $toFile
      if ($_.PSObject.Properties.Name -contains 'sha512') {
        # У�������ļ��� sha512 ֵ�Ƿ�ƥ��
        Write-Host "    ������ɣ�����ļ��� sha512 ֵ..."
        $realSha = Get-FileHash $toFile -Algorithm SHA512
        if ($realSha.Hash -eq $($_.sha512).ToUpper()) {
          Write-Host "    ���سɹ����ļ� sha512 ֵһ��"
        } else {
          Write-Host "    ���سɹ������ļ� sha512 ֵ����"
          Write-Host "      expected sha512=$($_.sha512)"
          Write-Host "      actual   sha512=$($realSha.Hash)"
        }
      } elseif ($_.PSObject.Properties.Name -contains 'sha256') {
        # У�������ļ��� sha256 ֵ�Ƿ�ƥ��
        Write-Host "    ������ɣ�����ļ��� sha256 ֵ..."
        $realSha = Get-FileHash $toFile -Algorithm SHA256
        if ($realSha.Hash -eq $($_.sha256).ToUpper()) {
          Write-Host "    ���سɹ����ļ� sha256 ֵһ��"
        } else {
          Write-Host "    ���سɹ������ļ� sha256 ֵ����"
          Write-Host "      expected sha256=$($_.sha256)"
          Write-Host "      actual   sha256=$($realSha.Hash)"
        }
      } else {
        Write-Host "    ���سɹ�"
      }
    } catch { 
      Write-Host "    ����ʧ��"
      Write-Host "    url=$url"
      Write-Host "    error=$_"
      # �����쳣��Ҫɾ����;���ص��ļ�
      if (Test-Path $toFile) {
        Remove-Item $toFile -Force
      }
    }
  } else {
    Write-Host "  �Ѵ��ڣ����Բ��ظ����� $($_.name) $($_.size) Release on $($_.date) to $toFile"
    if ($_.PSObject.Properties.Name -contains 'sha512') {
      # У�������ļ��� sha512 ֵ�Ƿ�ƥ��
      Write-Host "    ����ļ��� sha512 ֵ..."
      $realSha = Get-FileHash $toFile -Algorithm SHA512
      if ($realSha.Hash -eq $($_.sha512).ToUpper()) {
        Write-Host "    �ļ� sha512 ֵһ��"
      } else {
        Write-Host "    ���ļ� sha512 ֵ����"
        Write-Host "      expected sha512=$($_.sha512)"
        Write-Host "      actual   sha512=$($realSha.Hash)"
      }
    } elseif ($_.PSObject.Properties.Name -contains 'sha256') {
      # У�������ļ��� sha256 ֵ�Ƿ�ƥ��
      Write-Host "    ����ļ��� sha256 ֵ..."
      $realSha = Get-FileHash $toFile -Algorithm SHA256
      if ($realSha.Hash -eq $($_.sha256).ToUpper()) {
        Write-Host "    �ļ� sha256 ֵһ��"
      } else {
        Write-Host "    �ļ� sha256 ֵ����"
        Write-Host "      expected sha256=$($_.sha256)"
        Write-Host "      actual   sha256=$($realSha.Hash)"
      }
    }
  }
}

Write-Host $(Get-date) ����