Import-xml a module that run save Powershell Instances to xml and  rehydrate them for Powershell Instances 


## 简介
import-xml 利用 特殊的instance 类（可import-xml类）把整个powershell类保存到xml,xml保存有所有需要重新构建这个类的信息包括类的构建结构信息，通过rehydrate实现类的重构。
用于powershell 脚本 信息保存，生存表单，数据库等功能

## 介绍

import-xml 可以保存powershell类重构，保存类可以包含method,所以我们可以利用xml保存一个功能类，并重构
例子：
```
class hashtableInstance {
    [hashtable]$hash
    [string]$text
    hidden[string]$path= "$PSScriptRoot/xml/hashobject.xml"
    <# Define the class. Try constructors, properties, or methods. #>

  [void] DoInit() {
        # Empty DoInit method to init new-object
    }
    [void] DoInit(    [pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
    }
    hashtableInstance() {
        $this.hash= @{key1="value1"; key2="value2"}
        $this.text = 'text'
    }
    hashtableInstance([pscustomobject]$pscustomobject){

        $this.doinit($pscustomobject)
    }
   [object] save(){
        $hashproperty= ($this.hash.GetEnumerator()) 
        $hashxml=[xelement]::new("hashtable", ($hashproperty | ForEach-Object { [XElement]::new("key", $_.Value, [XAttribute]::new("name", $_.Key)) }))
        $content=[xelement]::new("object",[XAttribute]::new("name","hashtableInstance"),[XObject[]]@([XElement]::new("property",[XAttribute]::new("name","hash"),($hashxml)),[XElement]::new("property",[XAttribute]::new("name","text"),$this.text)))


        return $content.ToString()
    }
}
```



## 结构分析

import-xml 可以重构能被解析的instance 类

能被解析的类需要三个要素

### path

在类中添加 

```
hidden[string]$path=$psscriptroot/xml/myinstance.xml
```
### constructor

在类中添加
```
survival_place ($properties) {

   $this.DoInit($properties)
}
[void]DoInit ([hashtable]$properties){

   ForEach($property IN $properties.keys) {
       $this.$property=$properties.$property
   }
}
[void]DoInit ([pscustomobject]$pscustomobject){
       $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
       foreach($propertyName in $pscustomobjectName ){

          $this.$Propertyname= $pscustomobject.$Propertyname
       }
   }


```

### save method

在类中添加可以构建xml的方法

```
  [object] save(){
        $hashproperty= ($this.hash.GetEnumerator()) 
        $hashxml=[xelement]::new("hashtable", ($hashproperty | ForEach-Object { [XElement]::new("key", $_.Value, [XAttribute]::new("name", $_.Key)) }))
        $content=[xelement]::new("object",[XAttribute]::new("name","hashtableInstance"),[XObject[]]@([XElement]::new("property",[XAttribute]::new("name","hash"),($hashxml)),[XElement]::new("property",[XAttribute]::new("name","text"),$this.text)))


        return $content.ToString()
    }
```
