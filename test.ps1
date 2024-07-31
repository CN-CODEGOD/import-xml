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
[XElement]::new("param1",$this.param1



),
[XElement]::new("param2",$this.param2

),
[XElement]::new("param3",$this.param3   

)

)

}




}
