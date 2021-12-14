$Cname = Read-Host -Prompt "Input a Machine Name"
Invoke-Command -Computername $Cname -ScriptBlock {

$Regval = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC"
If(0 -eq $Regval ) {Write-Host "El valor ya es $Regval"}

Else{

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC" -Value "0"
$Regval = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" -Name "DisableFileSyncNGSC"
Write-Host "El valor ha sido cambiado a $Regval"

}


}



