# test.class.Tests.ps1

using namespace System.Xml.Linq

Describe 'testinstance class' {
    BeforeEach {
        $testInstance = [testinstance]::new()
    }

    It 'should initialize properties from PSCustomObject' {
        $pscustomobject = [pscustomobject]@{ txt = 'sample text'; name = 'sample name' }
        $testInstance.DoInit($pscustomobject)

        $testInstance.txt | Should -Be 'sample text'
        $testInstance.name | Should -Be 'sample name'   
    }

    It 'should save properties to XML' {
        $testInstance.txt = 'sample text'
        $testInstance.name = 'sample name'

        $xmlString = $testInstance.save()
        $xml = [XElement]::Parse($xmlString)

        $xml.Element('property').Attributes().Where({ $_.Name -eq 'name' -and $_.Value -eq 'txt' }).Count | Should -Be 1
        $xml.Element('property').Value | Should -Be 'sample text'

        $xml.Elements('property').Where({ $_.Attribute('name').Value -eq 'name' }).Value | Should -Be 'sample name'
    }
}