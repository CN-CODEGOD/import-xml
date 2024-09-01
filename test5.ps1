using namespace system.xml.linq
class test {
    [string]$string
    [int]$int
    [array]$array
    [pscustomobject]$test
    hidden $path="$psscript\test.xml"

    test ($value){
        $this.doinit($value)
    }

[void] DoInit(    [pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
    }
[void] DoInit (


[hashtable]$properties


)
{
    foreach ($property in $properties.key) {

        $this.$property =$properties.$property
    }
}

[object]save(){
    
$newobject =[XElement]::new("object",[XAttribute]::new("type","test"),
    [XElement]::new("property",[XAttribute]::new("name","string"),$this.string),
    [XElement]::new("property",[XAttribute]::new("name","int"),$this.int),
    [XElement]::new("property",[XAttribute]::new("name","array"),
       (  $this.array|foreach-object{
            [XElement]::new("value",$_)
        }
        
    )),
    [XElement]::new("property",[XAttribute]::new("name","test"),
        [XElement]::new("property",[XAttribute]::new("name","database"),"database"),
        [XElement]::new("property",[XAttribute]::new("name","username"),"username"),
        [XElement]::new("property",[XAttribute]::new("name","password"),"password")
        
    )
)
return $newobject.tostring()
}
}
