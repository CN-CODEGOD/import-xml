$a = New-Object PSObject -Property @{
    Name='New'
    Server = 'server'
    Database = 'database'
    UserName = 'username'
    Password = 'password'
}
 $a|convertto-xml -as string 
