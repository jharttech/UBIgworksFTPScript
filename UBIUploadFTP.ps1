<#Run RMUBIEXE to create xml file and place in correct location#>
$DTData = 'S:\U\DATAFILE'
CD $DTData
$Exemessage = "Running RMUBIEXE.EXE now..."
Write-Output $Exemessage
Start-Process S:\U\SUMMIT\RMUBIEXE.EXE S:\U\SUMMIT\ -Wait

<#Stage file for ftp upload to gworks server and make connection#>
$File = "S:\U\EXPORT\RMUBIEXP.xml"
$ftp = "ftp://USER:PASSWORD@ubi.gworks.com/processed/RMUBIEXP.xml"
$Stamp=get-date -f 'yyyy-MM-dd_HHmmss'

<#Set ftp URL#>
"ftp url: $ftp"

<#Create new webclient#>
$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftp)


$Message = "Uploading $File..."
Write-Output $Message
$webclient.UploadFile($uri, $File)

<#Give XML file a timestamp, move it, and then zip it up#>
Move S:\U\EXPORT\RMUBIEXP.XML "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"
ZIP -j -D "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.zip" "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"

<#Removing left over XML if new zip file exists#>
if (Test-Path "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.zip" -PathType leaf)
{
    Remove-Item "S:\U\EXPORT\Processed\RMUBIEXP_$Stamp.XML"
}

<#Download asp using created webclient above#>
"$webclient.DownloadString('https://ubi.gworks.com/%1/XMLFileImport.asp')"

<#Set ftp to passive#>
$ftp.Passive = $true
