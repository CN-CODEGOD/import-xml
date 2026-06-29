Describe "build-IN version" {
    BeforeAll{
        . $PSScriptRoot\test.class.ps1
       import-module $PSScriptRoot\import-xml.psm1
        
    }
    BeforeEach{
        $compliedInstance=Import-Xml .\xml\test.compliedInstance.xml
    }
    it 'import nestedInstance' {
        $compliedInstance|should -not -BeNullOrEmpty
        $compliedInstance.testInstance|Should -Not -BeNullOrEmpty
    }
}