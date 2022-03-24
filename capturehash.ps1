# Is the machine on? Ping the file share to find out:
$fileShareIp = "10.136.76.25";
IF (Test-Connection -BufferSize 32 -Count 1 -ComputerName $fileShareIp -Quiet) {
        Write-Host "The remote machine is online, installing and running AutoPilot...";
        RunInstallAutoPilot;
} Else {
        Write-Host "The remote machine is down. Program terminating";
}
function RunInstallAutoPilot {
    # Why do we have these lines? Are they needed? Commenting out the dir changes and new folder since we are writing directly to the share 
    # New-Item -Type Directory -Path "C:\HWID";
    # Set-Location -Path "C:\HWID";
    # $env:Path += ";C:\Program Files\WindowsPowerShell\Scripts";
    # Setup env to execute the script:
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force;
    # Install AutoPilot:
    Install-Script -Name Get-WindowsAutoPilotInfo -Scope CurrentUser -Force;
    # Get the machine name and output the file to the share:
    $machinename = hostname;
    Get-WindowsAutoPilotInfo -OutputFile "\\$fileShareIp\AutoPilot\$machinename.csv";
}