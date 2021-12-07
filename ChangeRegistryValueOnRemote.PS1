$Cname = Read-Host -Prompt "Input a Machine Name"
Invoke-Command -Computername $Cname -ScriptBlock {

$Regval = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC"
If(0 -eq $Regval ) {Write-Host "El valor ya es $Regval"}

Else{

Set-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC" -Value "1"

}

Write-Host "$Regval"

}



