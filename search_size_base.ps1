Remove-Variable * -ErrorAction SilentlyContinue

#
# Этот код ищет базы данных из своего списка и их размер в списке серверов
#
$x = 1
#read-host ""

$serverList = Get-Content "ServerList.txt"
$databaseList = Get-Content "DatabaseList.txt"
$query = "select count(name) from sysdatabases where name = '{0}'"
$queryexistbase = "SELECT COUNT(*) as [Count] FROM sys.objects"
#$querydbsizeGB = "SELECT SUM(CAST(size / 128.0 /1024 AS DECIMAL(17,2))) AS [Размер в GB] FROM sys.database_files"
$querydbsizeMB = "SELECT SUM(CAST(size / 128.0 AS DECIMAL(17,2))) AS [Размер в MB] FROM sys.database_files"
$outputPath = "Output.log"
$backupDirectory = "C:\backup"

foreach ($server in $serverList) {
    foreach ($dbname in $databaseList) {
        $queryDb = $query -f $dbname
        $SQLInstances = $server
        try {
            if ($(Invoke-SQLCmd -ServerInstance $SQLInstances -Database master -Query $queryDb -QueryTimeout 3600 -Verbose -ErrorAction Stop).Column1 -gt 0) {
                $results = Invoke-Sqlcmd -ServerInstance $server -Database $dbname -Query $queryexistbase -ErrorAction SilentlyContinue
                $dbSize = Invoke-Sqlcmd -ServerInstance $server -Database $dbname -Query $querydbsizeMB -ErrorAction SilentlyContinue
                if ($results) {
                    $count = $results.Count
                } else {
                    $count = 0
                }

                # Создать резервную копию базы данных
                $backupFile = "{0}\{1}_do_{2}.bak" -f $backupDirectory, $dbname, (Get-Date).AddDays($x).ToString("ddMMyyyy")
                Backup-SqlDatabase -ServerInstance $server -Database $dbname -BackupFile $backupFile

                Write-Output "$server,$dbname,$($dbsize.'Размер в MB')"
                #Write-host 'Размер SQL базы в MB' = $dbsize.'Размер в MB' # обрати внимание, здесь значение из массива, а не переменная и текст !!!!
                #Write-host 'Размер SQL базы в GB' = $dbsize.'Размер в GB'
                if ($count) {
                    Add-Content -Path $outputPath -Value "$server,$dbname,$($dbsize.'Размер в MB')"
                    Add-Content -Path $outputPath -Value "$(Get-Date -Format 'dd-MM-yyyy HH:mm'),$server,$dbname,$($dbsize.'Размер в MB')"

                } else {
                    Add-Content -Path $outputPath -Value "$server,$($dbsize.'Размер в MB')"
                }
            } else {
                Write-Warning "Database ${dbname} not found on server ${server}"
                Add-Content -Path $outputPath -Value "Database ${dbname} not found on server ${server}"
            }
        } catch {
            Write-Error "Error connecting to database ${dbname} on server ${server}: $_" -ErrorAction Continue
            Add-Content -Path $outputPath -Value "Error connecting to database ${dbname} on server ${server}: $_"
        }
    }
}

#Write-Host "Job Done!" -ForegroundColor Green -BackgroundColor Black
Get-Content "example.txt" | ForEach-Object {
    $_.ToCharArray() | ForEach-Object {
        Write-Host -NoNewline $_  -ForegroundColor Green -BackgroundColor Black
        Start-Sleep -Milliseconds 50
    }
}