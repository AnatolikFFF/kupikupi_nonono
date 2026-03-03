$root = "C:\Users"
$destRoot = "C:\Papka"  

$ext = @(
  "doc","docx","xls","xlsx","ppt","pptx",
  "pdf","txt","rtf","odt","ods","odp","csv",
  "jpg","jpeg","png","gif","tif","tiff","bmp",
  "zip","rar","7z"
)

New-Item -ItemType Directory -Path $destRoot -Force | Out-Null

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
