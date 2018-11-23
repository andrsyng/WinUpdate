#Проверяется аптайм
#Файл с IP
$IPfile = Get-Content C:\_Scripts\ip\ipForisSelected2.txt
#Если меньше часов чем $time, то выделяется красным
$time = 12
#=========

cls; Get-Date; Get-Job | Remove-Job
$IPfile | ForEach-Object{

start-job -Name $_ -ScriptBlock{
param ($_,$time)

Invoke-Command -ComputerName $_ {
param ($time)
Write-Host "===========  $(hostname)  ===========" 
######start
wuauclt /reportnow

$bt = Get-CimInstance -ClassName win32_operatingsystem | select lastbootuptime
$totalTime = (New-TimeSpan -Start $bt.lastbootuptime).TotalHours 

if($totalTime -le $time){
Write-Host "$([math]::Round($totalTime, 2)) Hours" -ForegroundColor red
} else{
Write-Host "$([math]::Round($totalTime, 2)) Hours" -ForegroundColor green
}


######
}  -ArgumentList $time


} -ArgumentList $_, $time | Format-Table
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

