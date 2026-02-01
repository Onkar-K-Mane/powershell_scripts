# ================================
# CONFIG
# ================================
$imageUrl  = "https://wallpapersafari.com/you-have-been-hacked-wallpaper/"   # <-- put your image link here
$savePath  = "$env:TEMP\downloaded_wallpaper.jpg"

# ================================
# DOWNLOAD IMAGE
# ================================
try {
    Invoke-WebRequest -Uri $imageUrl -OutFile $savePath -UseBasicParsing
}
catch {
    Write-Error "Failed to download image"
    exit 1
}

# ================================
# SET WALLPAPER (Windows API)
# ================================
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(
        int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE  = 0x01
$SPIF_SENDCHANGE     = 0x02

[Wallpaper]::SystemParametersInfo(
    $SPI_SETDESKWALLPAPER,
    0,
    $savePath,
    $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE
) | Out-Null
