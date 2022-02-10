#This is for local machine but can work on remote machines.
Invoke-Command {

 If (((get-item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\").Property) -Contains "HibernateEnabledDefault" -eq "True") { 
     write-output "HibernateEnabledDefault Exist" #--> Search the Property on the specified registry route and checks if exist.
}
Else { write-output "HibernateEnabledDefault does not Exist" #--> If the value does not exist, will notify. 
}
}
