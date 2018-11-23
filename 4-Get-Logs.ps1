#================
# IP 
$IPfile = Get-Content C:\_Scripts\ip\ipForisPROD.txt

cls
$IPfile | ForEach-Object{
write-host "===  $_  ===" -ForegroundColor Yellow

Invoke-Command -ComputerName $_ {
wuauclt /reportnow

try{
(Get-ScheduledTask myTask -ErrorAction Stop).State | ft | Tee-Object -Variable state 
if ($($state | Out-String) -notmatch 'Running'){write-host '!!! !!! !!! !!!' -ForegroundColor Red}
}catch{
Write-Host "No Task" -ForegroundColor Cyan
}

Get-Content C:\U\log.txt -Tail 10

try{
Get-Process TiWorker -ErrorAction Stop  |ft
}catch{Write-Host "Апдейты не загружаются/устанавливаются" -ForegroundColor Magenta}

} 

}






