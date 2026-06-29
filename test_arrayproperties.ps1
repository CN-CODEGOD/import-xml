describe "test arrayObject's properties and behavior" {
BeforeAll {
    # Load the class definition from the .ps1 file
        . .\test.class.ps1
    # Load the import-xml module
    Import-Module "$PSScriptRoot\import-xml.psm1" -Force}



    it 'test if the initialization of the arrayobect was correct' {
        $arrayInstance=[arrayobject]::new()
        $arrayInstance.array | Should -Not -BeNullOrEmpty
        $arrayInstance.array | Should -BeOfType [int]
        $arrayInstance.array | Should -HaveCount 5
        $arrayInstance.text | Should -Be "text"
    }
context "test the arrayobject properties" {

    it "test the save method of the arrayobject" {
        $arrayobject= [arrayobject]::new()
        $saveResult = $arrayobject.save()
        $saveResult | Should -Not -BeNullOrEmpty
        write-host "save result: $saveResult" -ForegroundColor Yellow
        write-host $saveResulT
    }

}

context "test the arrayonject behavior" {

}

AfterAll -skip {
    #clean up any created XML files
    Remove-Item -Path "$PSScriptRoot\xml\*.xml" -ErrorAction SilentlyContinue
}
}