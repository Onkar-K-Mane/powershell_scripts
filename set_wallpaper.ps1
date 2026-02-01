$imageUrl = "https://wallpapercave.com/wp/wp1922265.jpg"
$savePath = "$env:TEMP\wallpaper.jpg"

# Download the image
try {
    Invoke-WebRequest -Uri $imageUrl -OutFile $savePath -UseBasicParsing -ErrorAction Stop
}
catch {
    Write-Error "Failed to download image from $imageUrl"
    exit 1
}

# Set wallpaper via Windows API
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
