# import-xml

save manage import your class object 
the import-xml  will imoport object you save
the path of the saved object was default  $psscriptroot\xml

# 
import-xml -path [path] import the object from path
save-object -object [object] save the object to its  path 

# guidance

To write the import-xml you need the certain CODE inside your class to initialize with import-xml

## save method

to save object you need to add a SAVE method to initialize with save-object 

this is the template of the save method 

```
[object] save(){
    
    $object = [xelement]::new("object",[System.Xml.Linq.XAttribute]::new("type","road"),
        [xelement]::new("property",[XAttribute]::new("name","roadcoordinate"),
            [xelement]::new("property",[XAttribute]::new("name","roadcoordinate1"),
                [xelement]::new("property",[XAttribute]::new("name","x"),$this.roadcoordinate.roadcoordinate1.X),
                [xelement]::new("property",[XAttribute]::new("name","y"),$this.roadcoordinate.roadcoordinate1.Y),
                [xelement]::new("property",[XAttribute]::new("name","z"),$this.roadcoordinate.roadcoordinate1.Z)
            ),
          [xelement]::new("property",[XAttribute]::new("name","roadcoordinate2"),
                [xelement]::new("property",[XAttribute]::new("name","x"),$this.roadcoordinate.roadcoordinate2.X),
                [xelement]::new("property",[XAttribute]::new("name","y"),$this.roadcoordinate.roadcoordinate2.Y),
                [xelement]::new("property",[XAttribute]::new("name","z"),$this.roadcoordinate.roadcoordinate2.Z)
            )

        ),
        [xelement]::new("property",[XAttribute]::new("name","name"),$this.name),
        [xelement]::new("property",[XAttribute]::new("name","dimension"),$this.dimension),
        [xelement]::new("property",[XAttribute]::new("name","id"),$this.id)
    )
    return $object.tostring()
}
```


## path

the default of the path property, the import-xml will find the path property and store the object 

if the path dosen't exist ,import-object will create a new path 

you can get the store of the current object using import-xml $object.path

