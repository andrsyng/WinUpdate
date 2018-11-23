#Файл с IP
$IPfile = Get-Content C:\_Scripts\ip\ipForisPROD.txt
######
cls; Get-Date; Get-Job | Remove-Job
$proc=0
$ipCount= $IPfile.count
foreach($ip in $IPfile){
[double]$procIter = 20/$ipCount
$proc=$proc+$procIter
Write-Progress -Activity "Creating Tasks.." -Status "$([math]::Round($proc, 1)) %:" -PercentComplete ($proc)

start-job -Name $ip -ScriptBlock{
param ($ip)
Invoke-Command -ComputerName $ip {
param($ip)
Write-Host "====== $(hostname) ======" -ForegroundColor black -BackgroundColor white
######start


$free = ((Get-PSDrive) | where {($_).name -eq 'c'}).Free / 1GB
if($free -lt 3) { Write-Host "$([math]::Round($free, 2)) GB" -ForegroundColor darkred -BackgroundColor White
} elseif (($free -ge 3) -and ($free -lt 5)){Write-Host "$([math]::Round($free, 2)) GB" -ForegroundColor darkblue -BackgroundColor White
} else {
write-Host "$([math]::Round($free, 2)) GB" -ForegroundColor darkgreen -BackgroundColor White}



######end
} -ArgumentList $ip
} -ArgumentList $ip | Out-Null
} 



#Получаем результат из Jobs
cls

@'





'@
Get-Date | Tee-Object -Variable inDate

while((Get-Job).State -contains 'Running'){
Start-Sleep 1
$total = ((Get-Job).state).count
$now = ((Get-Job).State | where {$_ -eq 'Completed'}).count
$proc = ($now / $total) * 80 + 20
Write-Progress -Activity "Disk Space.." -Status "$([math]::Round($proc, 1)) %:" -PercentComplete ($($proc))
Get-Job | ForEach-Object {if($_.state -eq 'Completed'){$_ | Receive-Job} }
}

Get-Job | Receive-Job
""
write-host "$(($(Get-Date) - $inDate).Minutes) min" -ForegroundColor Cyan
