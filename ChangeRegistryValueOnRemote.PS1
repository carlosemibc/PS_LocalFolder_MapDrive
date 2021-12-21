$Cname = Read-Host -Prompt "Input a Machine Name" #--> Ask fot a machine name input.
Invoke-Command -Computername $Cname -ScriptBlock { #--> Starts the process to run commands on a domain remote machine.

$Regval = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC" #--> Obtains the value for an specific registry dword.
If(0 -eq $Regval ) {Write-Host "El valor ya es $Regval"} #--> If the value for dword is 0 writes out a message showing that the value is already 0.

Else{

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC" -Value "0" #--> If the value is not 0 then set the value for 0
$Regval = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC" # --> Set the variabale again to store the changes of the dword value.
Write-Host "El valor ha sido cambiado a $Regval" #--> Writes oute the message showing that the dword value has been changed.

}


}



