# ��ɫ����Զ���װ���õ� PowerShell �ű�
# ���ļ�����Ϊ ANSI ���� UTF-8

# �����û�����Ļ�������

## ��ȡ�������������ļ� `.env`
$envList = Get-Content -Path ".env"

Write-Output "�����û�����Ļ���������"
$envList | ForEach-Object {
  # ����ע���кͿ���
  if ($_ -notmatch "^#" -and $_.Length -gt 0) {
    $name, $value = $_ -split "="
    $name = $name.Trim()
    $value = $value.Trim()
    Write-Host "  $name=$value"

    # ���û�������
    if ($name -eq "Path") {
      $path = [Environment]::GetEnvironmentVariable('Path', 'User')
      Write-Host "  Original Path=$path"
    }
    [Environment]::SetEnvironmentVariable($name, $value, "User")
  }
}
