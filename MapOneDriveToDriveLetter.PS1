$PCName= Read-Host -Prompt 'Input the target machine name' # <--- Ask for machine name and stores it into a variable.
$UserIdent= ((Get-WmiObject -ComputerName $PCName -Class Win32_ComputerSystem).UserName).Split('\')[1] # --> Search the actual loged profile and stored it into a variable
$Route= "\\$PCName\c$\users\$UserIdent\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" # --> Stores the route for Startup folder for the target machine and logged profile
# File verification
Invoke-Command -Computername $PCName -scriptblock {

Param($PCName, $UserIdent, $Route)
If (Test-Path -Path $Route\TestPS.bat) {Write-Host "File already exist"} #--> Verify if the file exist on $Route.
Else {

New-Item -ItemType File -Path "$Route" -Name TestPS.bat # --> Creates the .bat file in the targeted route.
"net use o: /d /y" | Add-Content "$Route\TestPS.bat" #--> Write line in the .bat file
"`nsubst o: /d" | Add-Content "$Route\TestPS.bat" #--> Write line in the .bat file
"`nsubst o: ""%onedrive%""" | Add-Content "$Route\TestPS.bat" #--> Write line in the .bat file

} #--> If the file doesnt exist it will be created.
} -ArgumentList ($PCName, $UserIdent, $Route)
