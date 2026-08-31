

Describe "rehydrate function" {
    beforeALL {
        . "$PSScriptRoot/test.class.ps1"
        . "$PSScriptRoot/rehydrate.ps1"
        Import-Module importTestScript        

    
    }

    
context 'it test import-xml'  -skip{
  beforeEach {
        
    
      $nestedPscustomobject = [PSCustomObject]@{
            testInstance = [PSCustomObject]@{
                name = "default name"
                text = "default text"
            }
            text = "text"
        }
        $hashtablePsCustomObject=@([PSCustomObject]@{
    hash = @{key1 = "value1"; key2 = "value2"}
    text = "custom text"
            })
           $arrayPsCustomObject=@(
        [PSCustomObject]@{
            array = @(1, 2, 3,4,5)
            text = "text"
        }
    )
     $scriptblockPsCustomObject=@([PSCustomObject]@{
                scriptblock = {Write-Host "Hello, World!"}
                text = "text"})

      $hashtableXml=@"
    <objects>
    <object name="hashtableInstance" id="1">
    <property name="hash">
      <hashtable>
        <key name="key2">value2</key>
        <key name="key1">value1</key>
      </hashtable>
    </property>
    <property name="text">text</property>
  </object>
  </objects>
"@

$arrayxml=@"
<?xml version="1.0" encoding="utf-8"?>
    <objects>
<object name="arrayInstance" id="1">
    <property name="array">
      <array>
        <value index="0">1</value>
        <value index="1">2</value>
        <value index="2">3</value>
        <value index="3">4</value>
        <value index="4">5</value>
      </array>
    </property>
    <property name="text">Text</property>
  </object>
  </objects>
"@
$scriptblockxml=@"
<?xml version="1.0" encoding="utf-8"?>
     <objects>
     <object name="scriptblockInstance" id="1">
    <property name="scriptblock">
      <scriptblock>Write-Host "Hello, World!"</scriptblock>
    </property>
    <property name="text">text</property>
  </object>
  </objects>
"@

$nestedobjectXml=@"
<?xml version="1.0" encoding="utf-8"?>
<objects>
<object name="nestedInstance" id="1">
  <property name="testInstance">
    <property name="txt">default text</property>
    <property name="name">default name</property>
  </property>
  <property name="text">text</property>
</object>
</objects>
"@
    }

 it "test <name> of (<type>) with rehydrate" -foreach @(

 @{file="xml\array.xml";type="arrayInstance";name="array"}
 @{file="xml\hashobject.xml";type="hashtableInstance";name="hashtable"}
 @{file="xml\nestedInstance.xml";type="nestedInstance";name="nestedObject"}
 @{file="xml\scriptblockInstance.xml";type="scriptblockInstance";name="scriptblock"}
 )  {
  $importedObject =import-xml -path $file 
  $importedObject|should -not -benullorEmpty
  $importedObject |should -beoftype $type

 }

it "test rehydrate <type>" -ForEach @(
@{xmlContent= $nestedobjectXml;type="nestedInstance"}
@{xmlContent=$hashtableXml;type="hashtableInstance"}
@{xmlcontent=$arrayxml;type="arrayInstance"}
@{xmlcontent=$scriptblockxml;type="scriptblockInstance"}
){
  
         [xml]$xml = $xmlContent
        
        $object = $xml.objects.object
            $objectType = $object.name 
            if ([string]::IsNullOrEmpty($objectType)) {
                Write-Warning "Object type not specified in XML"
                continue
            }
            $rehydratedObject=rehydrate $object

            $rehydratedObject |should -not -benullorEmpty
            $rehydratedObject|should -BeOfType Pscustomobject
          Write-Host $rehydratedObject
 

} 
}
context "debugging rehydrate"{
 BeforeAll{
  mock Add-member{}
  
 }

context "it debug rehydrate nestedInstance" -skip{
  BeforeAll{

    

    <#mock rehydrate{} -Verifiable -ParameterFilter{ $dehydrated_object -eq  @"
<?xml version="1.0" encoding="utf-8"?>
<objects>
<object name="nestedInstance" id="1">
  <property name="testInstance">
    <property name="txt">default text</property>
    <property name="name">default name</property>
  </property>
  <property name="text">text</property>
</object>
</objects>
"@}#>
  

mock Add-Member -Verifiable -ParameterFilter { $name -eq "txt" -and $value -eq "default text" }
mock Add-Member -Verifiable -ParameterFilter { $name -eq "name" -and $value -eq "default name" }

mock Add-Member -Verifiable -ParameterFilter { $name -eq "text" -and $value -eq "text" }

         [xml]$xml = get-content -path .\xml\nestedInstance.xml
        
        foreach($object in $xml.objects.object) {
            $objectType = $object.name 
            if ([string]::IsNullOrEmpty($objectType)) {
                Write-Warning "Object type not specified in XML"
                continue
            }
          
              $pscustomObject = rehydrate $object
          
          

            
                
                
          
                
                
                
            
            
        }


  }
  it 'add-member invoking  '{
    
    should -Invoke -CommandName add-member  -Scope context -times 4

  
  }

  it 'should invoke corretly'{
    should -InvokeVerifiable 
  }
} 

context "it debug rehydrate arrayInstance"{
  beforeAll{

    mock Add-member -Verifiable -ParameterFilter { $name -eq "array" -and $value -eq @(1,2,3,4,5) }
    mock Add-Member -Verifiable -ParameterFilter { $name -eq "text" -and $value -eq "Text" }

         [xml]$xml = @"
<?xml version="1.0" encoding="utf-8"?>
<objects>
<object name="arrayInstance" id="1">
  <property name="array">
    <value>1</value>
    <value>2</value>
    <value>3</value>
    <value>4</value>
    <value>5</value>
  </property>
  <property name="text">Text</property>
</object>
</objects>
"@        

        foreach($object in $xml.objects.object) {
            $objectType = $object.name 
            if ([string]::IsNullOrEmpty($objectType)) {
                Write-Warning "Object type not specified in XML"
                continue
            }
          
              $pscustomObject = rehydrate $object
  }



}

it 'should invoke add-member for arrayInstance'{
  should -Invoke -CommandName add-member  -Scope context -times 2
}
it 'should invoke add-member with correct parameters for arrayInstance'{
  should -InvokeVerifiable




 }
}}}


