### Файл с IP 
$IPfile = Get-Content C:\_Scripts\ip\ipForisSelected.txt
###================================
### Create task: 1 | Delete task: 0  
$create = 1
###================================
$login = 'frs\asyngaievskyi'
$password = 'serop098U*'
### Поменяй пароль и домен !!! !!! !!!
###================================



cls; Get-Date; Get-Job | Remove-Job
$IPfile | ForEach-Object{

start-job -Name $_ -ScriptBlock{
param ($_, $create, $login, $password)
Invoke-Command -ComputerName $_ {
param ($_, $create, $login, $password)
Write-Host "====== $(hostname) ======" -ForegroundColor blue -BackgroundColor white
######start

#creating/removing task
if($create -eq 1){
###login/password
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument ' -file "C:\U\ForisUpdate.ps1"'
Register-ScheduledTask -Action $action -TaskName "myTask" -Description "Update Task" -User $login -Password $password -RunLevel Highest  | Out-Null
Write-Output "$(Get-Date): Scheduler. Creating task... " | out-file C:\U\log.txt -append
} elseif($create -eq 0){
Write-Output "$(Get-Date): Scheduler = Delete" | out-file C:\U\log.txt -append
try{
Stop-ScheduledTask myTask -ErrorAction Stop
Unregister-ScheduledTask myTask -Confirm:$false 
} catch{
Write-Host "The task is not found" -ForegroundColor yellow
Write-Output "$(Get-Date): Scheduler. The task is not found " | out-file C:\U\log.txt -append
}
Write-Output "$(Get-Date): Scheduler. Task deleted... " | out-file C:\U\log.txt -append
}
###########

#проверяется наличие таска
try{
Get-ScheduledTask myTask -ErrorAction Stop | Format-table
}catch{
Write-Host "No Task" -ForegroundColor Cyan
}

######end
} -ArgumentList $_, $create, $login, $password
} -ArgumentList $_, $create, $login, $password | Format-Table
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

