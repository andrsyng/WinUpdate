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

try{
Start-ScheduledTask -TaskName "myTask"
(Get-ScheduledTask myTask -ErrorAction Stop).State | ft | Tee-Object -Variable state
if ($($state | Out-String) -notmatch 'Running'){write-host '!!! !!! !!! !!!' -ForegroundColor Red}
}catch{
Write-Host "Error" -ForegroundColor Magenta
}


######end
} 
} -ArgumentList $_ | Format-Table
}


#Получаем результат из Jobs
while((Get-Job).State -contains 'Running'){
Start-Sleep 10
$total = ((Get-Job).state).count
$now = ((Get-Job).State | where {$_ -eq 'Completed'}).count
$proc = ($now / $total) * 100
Write-Host "$([math]::Round($proc, 2)) %" -ForegroundColor Green
}
cls
Get-Date

Get-Job | Receive-Job

