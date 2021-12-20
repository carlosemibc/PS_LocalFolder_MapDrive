Invoke-Command {

 If (((get-item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\").Property) -Contains "HibernateEnabledDefault" -eq "True") { 
     write-output "HibernateEnabledDefault Exist"
}
Else { write-output "HibernateEnabledDefault does not Exist"
}
}