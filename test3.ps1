$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
$root = "C:\Users"
$destRoot = "C:\Papka"
$logPath = "C:\ЛОГИ"

$ext = @(
    "doc","docx","xls","xlsx","ppt","pptx",
    "pdf","txt","rtf","odt","ods","csv",
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

$computerName = $env:COMPUTERNAME
$dateTime = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss")
$archiveName = "$computerName`_$dateTime"

$archivePath = Join-Path -Path $logPath -ChildPath "$archiveName.7z"

if (Test-Path $sevenZipPath) {
    & $sevenZipPath a -v2g "$archivePath" "$destRoot\*"
    "7-Zip used. Archive created: $archivePath"
} else {
    $zipFilePath = Join-Path -Path $logPath -ChildPath "$archiveName.zip"
    Compress-Archive -Path "$destRoot\*" -DestinationPath $zipFilePath -CompressionLevel Optimal
    "Standard Windows method used. Archive created: $zipFilePath"
}

Remove-Item -Path $destRoot -Recurse -Force
