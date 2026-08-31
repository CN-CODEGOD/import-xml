using namespace System.Xml.Linq

Describe "Save-Object" {
    BeforeAll {
        # Import required module
        Import-Module $env:OneDrive\modules\import-xml\import-xml.psm1
        
        # Test class definition
`
    }

    BeforeEach {
        # Setup test instance before each test
        $script:testInstance = [TestInstance]::new()
        $testObject = [PSCustomObject]@{ 
            txt = 'Sample text'
            name = 'Sample Name' 
        }
        $script:testInstance.DoInit($testObject)
    }

    Context "When saving objects to XML" {
        It "Should create a new XML file if it doesn't exist" {
            # Ensure test file doesn't exist
            if (Test-Path $script:testInstance.path) {
                Remove-Item $script:testInstance.path -Force
            }

            # Test save-object
            Save-Object $script:testInstance
            Test-Path $script:testInstance.path | Should -BeTrue
        }

        It "Should save object properties correctly" {
            Save-Object $script:testInstance
            $xml = [xml](Get-Content $script:testInstance.path)
            
            $savedObject = $xml.objects.object | Select-Object -Last 1
            $savedObject.property | Where-Object { $_.name -eq 'txt' } | 
                Select-Object -ExpandProperty '#text' | Should -Be 'Sample text'
            $savedObject.property | Where-Object { $_.name -eq 'name' } | 
                Select-Object -ExpandProperty '#text' | Should -Be 'Sample Name'
        }

        It "Should increment object ID for each save" {
            Save-Object $script:testInstance
            $xml = [xml](Get-Content $script:testInstance.path)
            $xml.objects.object[-1].id | Should -Not -BeNullOrEmpty
        }
        it "test the saved object"{
            Save-Object $script:testInstance
            $savedobject=import-xml $script:testInstance.path
            $savedobject | Should -BeOfType [TestInstance]
            $savedobject.txt[0] | Should -Be 'Sample text' 
            $savedobject.name[0] | Should -Be 'Sample Name'

        }   
    }

    AfterAll {
        # Cleanup test file
        if (Test-Path $script:testInstance.path) {
            Remove-Item $script:testInstance.path -Force
        }
    }
}