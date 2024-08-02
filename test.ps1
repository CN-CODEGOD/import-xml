using namespace system.xml.linq
class test {
[string]$param1
[int]$param2
[array]$param3
[psobject]$param4
[hashtable]$param5


hidden $path="c:\Users\邓深\test.xml"

test($param1,$param2,$param3,$param4,$param5) {
$this.param1=$param1
$this.param2=$param2
$this.param3=$param3
$this.param4=$param4
$this.param5=$param5

}
[object] save(){


$xml =[XElement]::new("test",
[XElement]::new("param1",

[XElement]::new("string",($this.param1|foreach-object {

  [XElement]::new("value",$_)
})


),
[XElement]::new("type","value")

),
[XElement]::new("param2",
[XElement]::new("int",($this.param2|foreach-object {

  [XElement]::new("value",$_)
})

),
[XElement]::new("type","value")
),
[XElement]::new("param3",
[XElement]::new("array",($this.param3|foreach-object {

  [XElement]::new("value",$_)
})



),
[XElement]::new("type","value")


)
,
[XElement]::new("param4",
[XElement]::new("psobject",
(($this.param4|Get-Member -Type NoteProperty |Select-Object -Property name).name|foreach-object{

[XElement]::new("$_",$this.param4.$_)

})


),
[XElement]::new("type","name")

)
,
[XElement]::new("param5",
($this.param5.keys|foreach-object{
  [XElement]::new("key",
  [XElement]::new("name",$_),
  [XElement]::new("value",$this.param5[$_])
  
  )

}
),
[XElement]::new("type","key")

)
)
return $xml.tostring()

}




    }
    
    $param4= New-Object PSObject -Property @{
    Name='New'
    Server = 'server'
    Database = 'database'
    UserName = 'username'
    Password = 'password'
}
$param5=[hashtable]@{
  name ='apple'
  type='fruit'
  color='red'
}
    $test=[test]::new(1,2,(1,2,3),$param4,$param5)
    $test|Get-Member
    
    