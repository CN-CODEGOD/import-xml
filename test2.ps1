$a = New-Object PSObject -Property @{
    Name='New'
    Server = 'server'
    Database = 'database'
    UserName = 'username'
    Password = 'password'
}
 $a | Convertto-XML -as string -NoTypeInformation
