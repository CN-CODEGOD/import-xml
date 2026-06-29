Describe "test nested object's behavior" {
    BeforeAll {
        . "$PSScriptRoot/test.class.ps1"
        import-module "$PSScriptRoot/import-xml.psm1"
    }
    Context 'behavior test' {
        it 'test the xml structure of nested object' {
            $nestedInstance=[nestedInstance]::new()
             write-host $nestedInstance.save()
             save-object $nestedInstance
                $xmlContent = Get-Content -Path $nestedInstance.Path -Raw
                write-host "XML Content:" -ForegroundColor Yellow
                write-host $xmlContent

        }
    }

    context 'import-xml testing the nested object' {
        it 'test the object itelf' {
            $nestedInstance= [nestedInstance]$nestedInstance=[nestedInstance]::new()
            save-object $nestedInstance
            $nestedsavedXML= Get-Content -Path $nestedInstance.Path -Raw
            [xml]$xmlDoc = $nestedsavedXML
            $xmlDoc.objects.object[1].property|should -Not -BeNullOrEmpty
            $xmlDoc.objects.object[1].name | Should -Be "nestedInstance"
            
        }
    }
}