#================
# Что копировать
$copyItem = "C:\_Scripts\Update\Teleport\U"
# IP Куда копировать на C:\
$IPfile = Get-Content C:\_Scripts\ip\ipForisPROD.txt
#================

cls
$IPfile | ForEach-Object{
write-host "===  $_  ===" -ForegroundColor Yellow
$copyItem

Copy-Item "$copyItem" \\$_\C$\ -Recurse 


Invoke-Command -ComputerName $_ {
param($copyItem)
$ID= $copyItem.Substring($copyItem.LastIndexOf('\')+1)
"C:\$ID"
ls "C:\$ID"
} -Args $copyItem

}

