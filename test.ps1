using namespace system.xml.linq
class test {
[string]$param1
[int]$param2
[array]$param3
hidden $path="c:\Users\邓深\test.xml"

test($param1,$param2,$param3) {
$this.param1=$param1
$this.param2=$param2
$this.param3=$param3

}
[object] save(){



return [XElement]::new("test",
[XElement]::new("param1",

[XElement]::new("value",($this.param1|ConvertTo-Xml -as String -NoTypeInformation)),
[XElement]::new("type",$this.param1.gettype())


),
[XElement]::new("param2",
[XElement]::new("value",($this.param2|ConvertTo-Xml -as String -NoTypeInformation)),
[XElement]::new("type",$this.param2.gettype())),
[XElement]::new("param3",
[XElement]::new("value",($this.param3|ConvertTo-Xml -as String -NoTypeInformation)),
[XElement]::new("type",$this.param1.gettype())


)

)

}




    }
    $test=[test]::new(1,2,(1,2,3))
    $test.save()