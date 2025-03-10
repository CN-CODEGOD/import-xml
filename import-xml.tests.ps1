using namespace System.Xml.Linq
import-module $env:onedrive\modules\import-xml\import-xml.psm1

Describe 'testinstance class' {
    BeforeAll {


            
            
      

        $testInstance = [testinstance]::new()
        $testObject = [pscustomobject]@{ txt = 'Sample text'; name = 'Sample Name' }
        $testInstance.DoInit($testObject)
 
        Remove-Item -Path $env:EXSYS_PATH\class\xml\test.xml -ErrorAction SilentlyContinue



    
    

 
    }

    Context 'test instance' {
        It 'should initialize properties from PSCustomObject' {
            $pscustomobject = [pscustomobject]@{ txt = 'sample text'; name = 'sample name' }
            $testInstance.DoInit($pscustomobject)
            $testInstance.txt | Should Be 'sample text'
            $testInstance.name | Should Be 'sample name'
        }
it 'test instace path'{

}

        It 'should save properties to XML' {
            $testInstance.txt = 'sample text'
            $testInstance.name = 'sample name'
            $xmlString = $testInstance.save()
            $xml = [XElement]::Parse($xmlString)
            $xml.Element('property').Attributes().Where({ $_.Name -eq 'name' -and $_.Value -eq 'txt' }).Count | Should Be 1
            $xml.Element('property').Value | Should Be 'sample text'
            $xml.Elements('property').Where({ $_.Attribute('name').Value -eq 'name' }).Value | Should Be 'sample name'
        }
    }

    Context 'test module' {
        It 'test save-object' {
            save-object $testInstance
        }

        It 'test import-xml' {
            $importinstance = import-xml $testInstance.path
            $importinstance.txt | Should Be "Sample text"
            $importinstance.name | Should Be "Sample Name"
        }

        It 'debug import-xml' {
        
            foreach ($object in $xml.objects.object) {
                $objecttype = $object.type
                $objecttype | Should Be "testinstance"
                $instance = New-Object TypeName $objecttype
                $pscustomobject = rehydrate $object
                $pscustomobject | Should BeOfType pscustomobject
                $instance.DoInit($pscustomobject)
                $instance | Should BeOfType testinstance
            }
        }
    }


    context 'test nestedinstance'{

        BeforeAll {

            $testInstance = [testinstance]::new()
            $testInstance.txt = "sample Text"
            $testInstance.name = "sample Name"
            
            # 创建 nested_instance 的实例
            $nested_Instance = [nested_instance]::new()
            $nested_Instance.testinstance = $testInstance
            $nested_Instance.name = "test"
            
            # 打印 nested_instance 的保存结果
            $nested_Instance.save()

        }
        it 'test nested_instance'{
            $nested_instance.testInstance.txt | Should Be 'sample text'
            $nested_instance.name | Should Be 'test'
            $xml=$nested_instance.save()
            [xml]$xml | Should BeOfType xml
            
        }
        it 'test save-object'{
            save-object $nested_instance
            test-path $nested_Instance.path |Should be  $true
            
        }

        it 'test import-xml'{
            
     $object=import-xml $nested_instance.path
        $object.testInstance.txt | Should Be 'sample text'
        $object.name | Should Be 'test'
        $object | Should BeOfType nested_instance
     


        }
 
  
   
    }
    context 'test hashtable_instance'{
        BeforeAll {
            $hashtable_instance = [hashtable_instance]::new()
            $hashtable_instance.name = "sample name"
            $hashtable_instance.hashtable = @{
                key1 = "value1"
                key2 = "value2"
            }
    
        }
        it 'test hashtable_instance'{
            $hashtable_instance.name | Should Be 'sample name'
            $hashtable_instance.hashtable | Should BeOfType hashtable
            $hashtable_instance.hashtable.key1 | Should Be 'value1'
            $hashtable_instance.hashtable.key2 | Should Be 'value2'
            $xml=$hashtable_instance.save()
            [xml]$xml | Should BeOfType xml

           
          
        }
    
        it 'test save-object'{
            save-object $hashtable_instance
            test-path $hashtable_instance.path |Should be  $true
            
        }
        it 'test import-xml'{
    $object=import-xml $hashtable_instance.path
    $object.name | Should Be 'sample name'
    $object.hashtable | Should BeOfType hashtable
    $object.hashtable.key1 | Should Be 'value1'
    
        }
        
    }

context 'test scriptblock_instance'{
    BeforeAll {
        $scriptblock_instance = [scriptblock_instance]::new()
        $scriptblock_instance.name = "sample name"
        $scriptblock_instance.scriptblock = {
            Write-Output "Hello, World!"
        }
    }
    it 'test scriptblock_instance'{
        $scriptblock_instance.name | Should Be 'sample name'
        $scriptblock_instance.scriptblock | Should BeOfType scriptblock
        $scriptblock_instance.scriptblock.Invoke() | Should Be 'Hello, World!'
        $xml=$scriptblock_instance.save()
        [xml]$xml | Should BeOfType xml

        $pscustomobject = [pscustomobject]@{ name = 'sample name'; scriptblock = { Write-Output "Hello, World!" } }
        $scriptblock_instance.DoInit($pscustomobject)| Should BeOfType scriptblock_instance
    }

    it 'test save-object'{
        save-object $scriptblock_instance
        test-path $scriptblock_instance.path |Should be  $true
        
    }
    it 'test import-xml'{
        $object=import-xml $scriptblock_instance.path
        $object.name | Should Be 'sample name'
        $object.scriptblock | Should BeOfType scriptblock
        $object.scriptblock.Invoke() | Should Be 'Hello, World!'

}
}}
