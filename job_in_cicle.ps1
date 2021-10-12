Remove-Variable * -ErrorAction SilentlyContinue
$sqlserver = "zxhome\sqlexpress"

$backup = @(Get-Content -Path "F:\SQL\backuplist.txt"| % {$_.Trim()})

$i = ForEach($backup1 in $backup) 
    {
    write-host "backupname:" $backup1
    $filename = $backup1
    $destinationpath = "f:\sql\backup\" + "$filename" + ".bak"
    write-host "destpath:" $destinationpath
    Start-Job -Name "$backup1" {Backup-SqlDatabase -ServerInstance "$sqlserver" -Database "$backup1" -BackupFile "$destinationpath" -CopyOnly}
    }

" "
"Get-Job | Wait-Job for view!"
"Get-Job | Remove-Job for remove jobs!"

Remove-Variable * -ErrorAction SilentlyContinue
