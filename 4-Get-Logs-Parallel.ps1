### Файл с IP 
$IPfile = Get-Content C:\_Scripts\ip\ipForisPROD.txt
###================================

cls; Get-Date; Get-Job | Remove-Job
$IPfile | ForEach-Object{

start-job -Name $_ -ScriptBlock{
param ($_)
Invoke-Command -ComputerName $_ {
Write-Host "====== $(hostname) ======" -ForegroundColor Yellow
######start

wuauclt /reportnow

try{
(Get-ScheduledTask myTask -ErrorAction Stop).State |ft 
}catch{
Write-Host "No Task" -ForegroundColor Cyan
}

Get-Content C:\U\log.txt -Tail 10

try{
Get-Process TiWorker -ErrorAction Stop  |ft
}catch{Write-Host "Апдейты не загружаются/устанавливаются" -ForegroundColor Magenta}




######end
} 
} -ArgumentList $_ | Format-Table
}


#Получаем результат из Jobs
cls
Get-Date | Tee-Object -Variable inDate
@'





'@
while((Get-Job).State -contains 'Running'){
Start-Sleep 3
$total = ((Get-Job).state).count
$now = ((Get-Job).State | where {$_ -eq 'Completed'}).count
$proc = ($now / $total) * 100
Write-Progress -Activity "Wait.." -Status "$([math]::Round($proc, 1)) %:" -PercentComplete ($($proc))
Get-Job | ForEach-Object {if($_.state -eq 'Completed'){$_ | Receive-Job} }
}

Get-Job | Receive-Job
""
write-host "$(($(Get-Date) - $inDate).Minutes) min" -ForegroundColor Cyan
