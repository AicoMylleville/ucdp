$PCList = (Get-ADComputer -Filter {Name -notlike "*Server*" -And Name -notlike "CORE*" -And Name -notlike "GUI*" -And Enabled -ne $False}).Name
[Array]::Sort($PCList)

ForEach ($PC in $PCList){
	If (Test-Connection $PC -Count 1 -Quiet)
	{
                Write-Host "Checking if firewall rule to open port 9090 exist on: $PC"
                if(!(Invoke-Command -Computername $PC -ScriptBlock {Get-NetFirewallRule -DisplayName "Windows Exporter"}))
                {
                        Write-Host "    Adding firewall rule to open the port on: $PC"
                        Invoke-Command -Computername $PC -ScriptBlock {New-NetFirewallRule -DisplayName "Windows Exporter" -Direction Inbound -Program "C:\WindowsExporter\WindowsExporter.exe" -LocalPort 9090 -Protocol TCP -Action Allow}
                }

                Write-Host "Download and/or run windows_exporter on: $PC"
                Invoke-Command -FilePath C:\windows_exporter.ps1 -ComputerName $PC
	}
}
