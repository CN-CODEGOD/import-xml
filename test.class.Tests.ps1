# test.class.Tests.ps1



using namespace System.Xml.Linq

BeforeAll {
    # Load the class definition from the .ps1 file
        . "$PSScriptRoot\test.class.ps1"
    # Load the import-xml module

    Import-Module "$PSScriptRoot\import-xml.psm1" -Force
    #cleanup the xml file after test
    Remove-Item "$PSScriptRoot\xml\*.xml" -ErrorAction SilentlyContinue
    }



Describe 'Test import-xml and save-object with different property types' {
   
    Context 'Test nested properties' {

        it 'test If the initialization of nested properties works correctly' {
            $nestedInstance=[nestedInstance]::new()
            $nestedInstance.testInstance.txt | should -be "default text"
            $nestedInstance.testInstance.name |Should -be "default name"
            $nestedInstance.text |Should -be "text"

    }

       # 成功保存对象后，XML文件正确反映对象的结构和属性值。
it 'test save-object with nested properties'  -skip {
    $nestedInstance=[nestedInstance]::new()
    save-object $nestedInstance
    
    $xmlContent = Get-Content -Path $nestedInstance.Path -Raw
    Write-Host "XML Content:" -ForegroundColor Yellow
    Write-Host $xmlContent
    
    [xml]$xmlDoc = $xmlContent
    $xmlDoc | Should -Not -BeNullOrEmpty
    # 检查根元素
    $xmlDoc.objects.object.name | Should -Be "nestedInstance"
    
    # 检查嵌套属性
    $xmlDoc.objects.object.property | Where-Object { $_.name -eq "testInstance" } | Should -Not -BeNullOrEmpty
    $xmlDoc.objects.object.property | Where-Object { $_.name -eq "text" } | Select-Object -ExpandProperty '#text' | Should -Be "text"
  
    # 检查 testInstance 内的 txt 和 name
    $testInstanceProperty = $xmlDoc.objects.object.property | Where-Object { $_.name -eq "testInstance" }
    $testInstanceProperty.property | Where-Object { $_.name -eq "txt" } | Select-Object -ExpandProperty '#text' | Should -Be "default text"
    $testInstanceProperty.property | Where-Object { $_.name -eq "name" } | Select-Object -ExpandProperty '#text' | Should -Be "default name"
}

        it 'test import-xml with nested properties'  {
            $nestedInstance=[nestedInstance]::new()
            save-object $nestedInstance
            $nestedInstance.path | Should -be $psscriptroot/xml/nestedInstance.xml
            $importedInstance = import-xml -Path $nestedInstance.Path
            $importedInstance | Should -Not -BeNullOrEmpty

            $importedInstance.text | Should -Be $nestedInstance.text
            $importedInstance.testInstance.txt | Should -Be $nestedInstance.testInstance.txt
            $importedInstance.testInstance.name | Should -Be $nestedInstance.testInstance.name
        }
    }

    Context 'Test scriptblock properties'  {

        it 'test If the initialization of scriptblock properties works correctly' {
            $scriptblockInstance=[scriptblockInstance]::new()
            $scriptblockInstance.scriptblock.ToString() | Should -Be "Write-Host ""Hello, World!"""
            $scriptblockInstance.text | Should -Be "text"
        }
        it 'test save-object with scriptblock properties' {
            $scriptblockInstance=[scriptblockInstance]::new()
            
            $scriptblockInstance.text | Should -Be "text"
            save-object $scriptblockInstance
            $xmlContent = Get-Content -Path $scriptblockInstance.Path -Raw
           $xmlDoc = [xml]$xmlContent
            $scriptblockNode = $xmlDoc.objects.object.property | Where-Object { $_.name -eq "scriptblock" } | Select-Object -ExpandProperty scriptblock
            $scriptblockNode | Should -Not -BeNullOrEmpty
            $scriptblockNode | Should -Contain "Write-Host ""Hello, World!"""
            $xmlDoc.objects.object.property | Where-Object { $_.name -eq "text" } | Select-Object -ExpandProperty '#text' | Should -Be "text"
        }
        it 'test import-xml with scriptblock properties' -skip {
            $scriptblockInstance=[scriptblockInstance]::new()
            save-object $scriptblockInstance
            $importedInstance = import-xml -Path $scriptblockInstance.Path
            $importedInstance.text | Should -Be $scriptblockInstance.text
            $importedInstance.scriptblock.ToString() | Should -Be $scriptblockInstance.scriptblock.ToString()
        }
    }
        
    context 'Test hash properties'  {

        it 'test If the initialization of hash properties works correctly' {
            $hashInstance=[hashtableInstance]::new()
            $hashInstance.hash["key1"] | Should -Be "value1"
            $hashInstance.hash["key2"] | Should -Be "value2"
            $hashInstance.text | Should -Be "text"
        }
        it 'test save-object with hash properties'  {
            $hashInstance=[hashtableInstance]::new()
            
            $hashInstance.text | Should -Be "text"
            save-object $hashInstance
            $xmlContent = Get-Content -Path $hashInstance.Path -Raw
            $xmlDoc = [xml]$xmlContent
            
            $hashNode = $xmlDoc.objects.object.property | Where-Object { $_.name -eq "hash" }|select-object -ExpandProperty hashtable
            
            $hashNode | should -Not -BeNullOrEmpty
            $hashNode.key | Should -Not -BeNullOrEmpty
            foreach($key in $hashInstance.hash.Key){
                $hashNode | Where-Object { $_.name -eq $key } | Select-Object -ExpandProperty '#text' | Should -Be $hashInstance.hash[$key]
            }
            $xmlDoc.objects.object.property | Where-Object { $_.name -eq "text" } | Select-Object -ExpandProperty '#text' | Should -Be "text"
        }

        it 'test import-xml with hash properties' -skip {
            $hashInstance=[hashtableInstance]::new()
            save-object $hashInstance
            $importedInstance = import-xml -Path $hashInstance.Path
            $importedInstance.text | Should -Be $hashInstance.text
            foreach($key in $hashInstance.hash.Keys){
                $importedInstance.hash.$key | Should -Be $hashInstance.hash.$key
            }
        }
    }

    Context 'Test array properties' {

        it 'test If the initialization of array properties works correctly' {
            $arrayInstance=[arrayInstance]::new()
            $arrayInstance.array | Should -Be @(1, 2, 3, 4, 5)
            $arrayInstance.text | Should -Be "text"
        }
        it 'test save-object with array properties'  {
            $arrayInstance=[arrayInstance]::new()
            save-object $arrayInstance
            $xmlContent = Get-Content -Path $arrayInstance.Path -Raw
            $xmlDoc = [xml]$xmlContent
            $xmlDoc | Should -Not -BeNullOrEmpty
            $xmlDoc.objects.object.property|should -Not -BeNullOrEmpty
            $arrayNode = $xmlDoc.objects.object.property | Where-Object { $_.name -eq "array" }|select-object -ExpandProperty array
            $arrayNode | Should -Not -BeNullOrEmpty
            $arrayValues = $arrayNode | Select-Object -ExpandProperty value
            $arrayValues | Should -Not -BeNullOrEmpty
            $arrayValues.Count | Should -Be $arrayInstance.array.Length
            
            $xmlDoc.objects.object.property | Where-Object { $_.name -eq "text" } | Select-Object -ExpandProperty '#text' | Should -Be "text"
        }

        it 'test import-xml with array properties' -skip {
            $arrayInstance=[arrayInstance]::new()
            save-object $arrayInstance
            $importedInstance = import-xml -Path $arrayInstance.Path
            $importedInstance.text | Should -Be $arrayInstance.text
            for($i=0; $i -lt $arrayInstance.array.Length; $i++){
                $importedInstance.array[$i] | Should -Be $arrayInstance.array[$i]
            }
        }
    }

    AfterAll{
        

    }
}