#-->This script will add a domain account to local admin group on a domain machine.
$PCName= Read-Host -Prompt "Input machine name" #--> Ask for domain machine name
$username = Read-Host -Prompt "input username" #--> Ask for account, must be USER LOGON NAME on AD, not NAME.
Invoke-Command -Computername $PCName -scriptblock {
Param($PCName, $username)
Add-LocalGroupMember -Group "Administrators" -Member "$username@domain.org" #--> Will add account to loacal admin group on targeted machine.
} -ArgumentList ($PCName, $username)
