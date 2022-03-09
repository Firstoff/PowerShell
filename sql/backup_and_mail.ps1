# Делаем бекап MS SQL базы и шлем отчет на почту.

$sqlbase = "имя_базы"
$sqlserver = "скл-сервер"
$daten = read-host "До какой даты хранить?"
$destinationpath = "\\"+ "$sqlserver" + "\ob$" + "\not_del_" + "$sqlbase" + "_do" + "$daten" + ".bak"

Backup-SqlDatabase -ServerInstance "$sqlserver" -Database "$sqlbase" -BackupFile "$destinationpath" -CompressionOption On -CopyOnly
Send-MailMessage -From user_1@domain.org -To user_2@domain.org -SmtpServer exch2.domain.org -Subject "$sqlbase" -Body "Backup ready";
