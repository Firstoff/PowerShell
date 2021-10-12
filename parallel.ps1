$result = ForEach-Object - Parallel -InputObject @('localhost','127.0.0.1') -Process {Get-Service -ComputerName $PSItem} -TrottleLimit 10
$result -expand