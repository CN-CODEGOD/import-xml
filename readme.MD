Import-xml a module that run save Powershell Instances to xml and  rehydrate them for Powershell Instances 


## 简介
import-xml 利用 特殊的instance 类（可import-xml类）把整个powershell类保存到xml,xml保存有所有需要重新构建这个类的信息包括类的构建结构信息，通过rehydrate实现类的重构。
用于powershell 脚本 信息保存，生存表单，数据库等功能

## 介绍

import-xml 可以保存powershell类重构，保存类可以包含method,所以我们可以利用xml保存一个功能类，并重构
例子：
```
class survival_place {
 [System.Numerics.Vector3]$placecoordinate
   [dimension]$dimension
   [place_type]$type
   [int]$id
   hidden $path = "$PSScriptRoot\xml\survival_place.xml"

   ### construct 
survival_place ($properties) {

   $this.DoInit($properties)
}
   
   ### Method
#### DoInit
[void]DoInit ($value){ 
   [int32]$attempt=-1
   if ([int32]::TryParse($value,[ref]$attempt))
   {
       $this.id=$attempt
   }
   else
   {   
       $this.id  =-1
       $this.type=$value
   }
}
#### Doinit
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
   [Object]save(){

       $object = [XElement]::new("object",[XAttribute]::new("name","survival_place"),

       [XElement]::new("property",[XAttribute]::new("name","placecoordinate"),
       [XElement]::new("property",[XAttribute]::new("name","x"),$this.placecoordinate.x),
       [XElement]::new("property",[XAttribute]::new("name","y"),$this.placecoordinate.y),
       [XElement]::new("property",[XAttribute]::new("name","z"),$this.placecoordinate.z)

       
       
       ),
       [XElement]::new("property",[XAttribute]::new("name","dimension"),$this.dimension),
       [XElement]::new("property",[XAttribute]::new("name","type"),$this.type),
       [XElement]::new("property",[XAttribute]::new("name","id"),$this.id)
       )
       return $object.ToString()
   }

#### validation mathod for repeat adding
  static [void]validate ([survival_place]$survival_place,[int]$distance_limit){
       $survival_places = Import-xml $PSScriptRoot\xml\survival_places.xml|Where-Object {$_.type -like $survival_place.type -and $_.dimension -like $survival_place.dimension}
   
     $survival_places|foreach-object {
      $distance= [System.Numerics.Vector3]::Distance($survival_place.placecoordinate,$_.placecoordinate)

       if ($distance -lt $distance_limit) {
           throw "坐标重复"
       }
        
     }


   }

}
```
```
#### validation mathod for repeat adding
  static [void]validate ([survival_place]$survival_place,[int]$distance_limit){
       $survival_places = Import-xml $PSScriptRoot\xml\survival_places.xml|Where-Object {$_.type -like $survival_place.type -and $_.dimension -like $survival_place.dimension}
   
     $survival_places|foreach-object {
      $distance= [System.Numerics.Vector3]::Distance($survival_place.placecoordinate,$_.placecoordinate)

       if ($distance -lt $distance_limit) {
           throw "坐标重复"
       }
        
     }


   }
```
可以直接使用类的方法，方便打包，整洁程序，更干净




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
  [Object]save(){

       $object = [XElement]::new("object",[XAttribute]::new("name","survival_place"),

       [XElement]::new("property",[XAttribute]::new("name","placecoordinate"),
       [XElement]::new("property",[XAttribute]::new("name","x"),$this.placecoordinate.x),
       [XElement]::new("property",[XAttribute]::new("name","y"),$this.placecoordinate.y),
       [XElement]::new("property",[XAttribute]::new("name","z"),$this.placecoordinate.z)

       
       
       ),
       [XElement]::new("property",[XAttribute]::new("name","dimension"),$this.dimension),
       [XElement]::new("property",[XAttribute]::new("name","type"),$this.type),
       [XElement]::new("property",[XAttribute]::new("name","id"),$this.id)
       )
       return $object.ToString()
   }

```
