I have try to import the object with clixml ,it doesn't work well

so i try my own module ,if you want to recreate the object and save the object for use .

this is the right module for you

git hub :https://github.com/CN-CODEGOD/import-xml

To store the object, you need to add some code inside the class

1.path property

the path property will tell the module where to store your object

you can use import-xml $object.path to import the object from xml

2.initialize

to iniitialize the object you need to add a contruct flowing

[void] DoInit(    [pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
    }
3.save method

to save the object ,you need to add a save method inside the object manually,which will generate the xml from object

here is a simple example

[object] save(){
    
    $object= [XElement]::new("object",[XAttribute]::new("type","password"),
    [XElement]::new("property",[XAttribute]::new("name","username"),$this.username),
    [XElement]::new("property",[XAttribute]::new("name","password"),$this.password)
    
    )
    return $object.ToString()

}
to learn more go to check my my github page https://gist.github.com/CN-CODEGOD/dd415e0ab67f5f900982bfa227b11c47

advantage :

1.you can simply create the object and save easily,and use it in future

2.since it was a xml file , you can use the xml file in your website or in other language like js or node without problem

3.it can manage the object with saving and import

i will appreciate it if you can Forward my project to others