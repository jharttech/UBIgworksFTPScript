$DTData = 'S:\U\DATAFILE'
CD $DTData
Start-Process S:\U\SUMMIT\RMUBIEXE.EXE S:\U\SUMMIT\ -Wait




$File = "S:\U\EXPORT\RMUBIEXP.xml"
$ftp = "ftp://USER:PASSWORD@ubi.gworks.com/processed/RMUBIEXP.xml"
$Stamp=get-date -f 'yyyy-MM-dd_HHmmss'

"ftp url: $ftp"

$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftp)

"Uploading $File..."

$webclient.UploadFile($uri, $File)



Move S:\U\EXPORT\RMUBIEXP.XML "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"
ZIP -j -D "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.zip" "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"
if (Test-Path "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.zip" -PathType leaf)
{
    Remove-Item "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"
}



"$webclient.DownloadString('https://ubi.gworks.com/%1/XMLFileImport.asp')"


$ftp.Passive = $true
