  beforeALL {
        . "$PSScriptRoot/test.class.ps1"
        
        import-module import-xml
        

        
    }


Describe "Import-Xml import object correctly" {

  
   
    



context 'debug import-xml'{

    beforeAll{
    
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
            array = @(1, 2, 3)
            text = "text"
        }
    )

    $scriptblockPsCustomObject=@([PSCustomObject]@{
                scriptblock = {Write-Host "Hello, World!"}
                text = "text"})

            
$xmlContent = @"
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

    
        Mock -modulename import-xml Get-Content { return $xmlContent }
        mock -moduleName import-xml rehydrate {return $nestedPscustomobject}
        mock -moduleName import-xml new-object {} 
       
       
          try {
            import-xml .\Example_Instances.xml
        } catch {
            Write-Host "Error in import-xml: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor Yellow
            throw  # Re-throw to fail the test
        }
       
    }




it 'should  invoke get-content 1 times'{

    should -invoke -moduleName import-xml -commandName get-content -times 1 -scope context  
}

it 'should invoke rehydrate 1 times'{

    should -Invoke -moduleName import-xml -commandName rehydrate -times 1  -scope context 
}

it 'test if the new-object type name was correctly called'{
    should -Invoke -moduleName import-xml -commandName NEW-OBJECT -ParameterFilter {$typeName -eq "nestedInstance"} -scope context
}

it "test if the new-object was called to create the nestedObect"{
    should -Invoke -moduleName import-xml -commandName new-object -ParameterFilter {

        $argumentlist -eq $nestedPscustomobject 
    } -scope context

    
}
}   
    

describe 'intialize object' { 

    context "Intialize nestedObject"   {
    

       beforeAll{
        
    
      $nestedPscustomobject = [PSCustomObject]@{
            testInstance = [PSCustomObject]@{
                name = "default name"
                text = "default text"
            }
            text = "text"
        }


               
$xmlContent = @"
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
  

    
        Mock -modulename import-xml Get-Content { return $xmlContent }
        mock -moduleName import-xml rehydrate {return $nestedPscustomobject}
        
       
       
          
           
        
       
    }




    it 'nestedObject' {
        
           
       $object= import-xml .\Example_Instances.xml
        
        
        
        $object | Should -Not -BeNullOrEmpty
        $object.text|should -be "text"
        $object.testInstance.name|should -be "default name"
        $object.testInstance.text|should -be 'default text'
       


    }
    
}

context "it initialize hashtable Instance" {

    beforeAll{
        $hashtablePsCustomObject=@([PSCustomObject]@{
    hash = @{key1 = "value1"; key2 = "value2"}
    text = "custom text"
            })



    $xmlContent = @"
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
 
        Mock -modulename import-xml Get-Content { return $xmlContent }
        mock -moduleName import-xml rehydrate {return $hashtablePscustomobject}
        
       
       

    }


it 'hashtableobject'  {
    $object =import-xml -path ./example_instances.xml
    $object|should -not -BeNullOrEmpty
    $object.hash.key2|should -be "value2"
    $object.hash.key1|should -be "value1"
    $object.text|should -be "custom text"
    return $object
}
}
context "it intialize arrayObject"{
beforeAll{
           $arrayPsCustomObject=@(
        [PSCustomObject]@{
            array = @(1, 2, 3,4,5)
            text = "text"
        }
    )

    $xmlContent=@"
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
 
        Mock -modulename import-xml Get-Content { return $xmlContent }
        mock -moduleName import-xml rehydrate {return $arrayPscustomobject}
        
       
       


}
it 'arrayObject'{
    
$object=import-xml -path ./example_instances.xml
$object|Should -Not -BeNullOrEmpty
$object.array[0]|should -be 1
$object.array[1]|should -be 2
$object.array[2]|should -be 3
$object.array[3]|should -be 4
$object.array[4]|should -be 5
$object.text|should -be "text"

}

}

context "scriptblockObject"{
    beforeAll{
     $scriptblockPsCustomObject=@([PSCustomObject]@{
                scriptblock = {Write-Host "Hello, World!"}
                text = "text"})

     $xmlContent= @"
     <objects>
     <object name="scriptblockInstance" id="1">
    <property name="scriptblock">
      <scriptblock>Write-Host "Hello, World!"</scriptblock>
    </property>
    <property name="text">text</property>
  </object>
  </objects>
"@   

 
        Mock -modulename import-xml Get-Content { return $xmlContent }
        mock -moduleName import-xml rehydrate {return $scriptblockPscustomobject}
        
       
       

    }
    it 'scriptblockObject' {
        
        $object=import-xml -path ./example_instances.xml
        $object|should -not -BeNullOrEmpty
         $object.scriptblock|should -be 'Write-Host "Hello, World!"'
        $object.text |should -be "text"
        $object.scriptblock|should -beoftype "scriptblock"

        return $object
    }
}

}

}