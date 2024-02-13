$machineList = "C:\Machines.txt" #File containing list of machines to be policy updated
$MachineListVerify = "C:\MachinesVerified.txt" #File containing results of policy updating
Remove-Item -Path $MachineListVerify -Recurse -Force #Remove old results file after every run
New-Item -ItemType File -Path $MachineListVerify #Create a new result file after evry run
$machineName = Get-Content $machineList #Get the machine names from list of machines file
$creds = Get-Credential #Ask for credentials

#Start a loop to iterate on every machine on list of machines

foreach ($machine in $machineName) {
    try {
       

        $folderPath = "\\$machine\c$\Windows\System32\GroupPolicy" #Folder path for GroupPolicy
        $remoteIP = Test-Connection -ComputerName $machine -Count 1 -ErrorAction Stop | Select-Object -ExpandProperty IPV4Address
    } catch {
        Write-Host "Error obtaining information from $machine"
        "$machine Error" | Out-File -FilePath $MachineListVerify -Append
        continue
    }

     #Looks for machine IP if no IP machine is offline and if no IP found will show as diconnected and jump to next one

    if (-not $remoteIP) {
        Write-Host "$machine Offline"
        "$machine Offline" | Out-File -FilePath $MachineListVerify -Append
        continue 
    }

    #Look for the GroupPolicy folder if not found will report machine as error and jump to next one

    try {
        $items = Get-ChildItem $folderPath\ -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Error obtaining $folderPath on $machine"
        "$machine Error" | Out-File -FilePath $MachineListVerify -Append
        continue 
    }

     #Looks for GroupPolicy folder content if does not find any content will force the policy update
    

    if ($items.Count -eq 0) {
        Write-Host "$machine IP is $remoteIP"
        Write-Host "No files found"
        try{       
        Invoke-GPUpdate -Computer $machine -RandomDelayInMinutes 0 -ErrorAction Stop
        $count = 0
     
     #Validate if update is ok by looking new files created inside GroupPolicy folder after policy update

        while ((Get-ChildItem -Path $folderPath\ -ErrorAction SilentlyContinue).Count -eq 0) {
            $count++
            Write-Host "Policy has not been updated yet. Wait: $count"
            Start-Sleep -Seconds 5

    #Time out is set to update policy, if its not updated will report machine with error and jump to next one

            if ($count -eq 10) {
        Write-Host "Error: Policy update has not occurred within the expected time."
        "$machine Error" | Out-File -FilePath $MachineListVerify -Append
        break  
    }
        }

    #Look for new files inside the GroupPolicy folder after policy update if found will report machine as OK 

        if ($count -ne 10) {
    "$machine OK" | Out-File -FilePath $MachineListVerify -Append
    Write-Host "Policy Updated. Elapsed time: $count"
}

    #If policy cannot be updated for any error, will put the machine with error on resluts and jump to next one

} catch {
Write-Host "Error: Policy update error."
"$machine Error" | Out-File -FilePath $MachineListVerify -Append
}

    #If found any content inside the GroupPolicy folder will wipe it and runs policy update
  
    
    } else {
        Write-Host "$machine IP is $remoteIP"
        Write-Host "Some files found"
        Remove-Item -Path $folderPath\* -Recurse -Force     
        try {
        Invoke-GPUpdate -Computer $machine -RandomDelayInMinutes 0 -ErrorAction Stop
        $count = 0

    #Will look for new files after policy update, if found will report machine as OK.

        while ((Get-ChildItem -Path $folderPath\ -ErrorAction SilentlyContinue).Count -eq 0) {
    $count++
    Write-Host "Policy has not been updated yet. Wait: $count"
    Start-Sleep -Seconds 5

    #Time out is set to update policy, if its not updated will report machine with error and jump to next one

    if ($count -eq 10) {
        Write-Host "Error: Policy update has not occurred within the expected time."
        "$machine Error" | Out-File -FilePath $MachineListVerify -Append
        break  
    }
}

    if ($count -ne 10) {
        "$machine OK" | Out-File -FilePath $MachineListVerify -Append
        Write-Host "Policy Updated. Elapsed time: $count"
}

    #If got any error on policy update will repor machine with an Error

} catch {
Write-Host "Error: Policy update error."
"$machine Error" | Out-File -FilePath $MachineListVerify -Append
}
        
    }
} 
