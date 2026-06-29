Describe "debug arrayInstance" {
    BeforeAll {
        . ./rehydrate.ps1
        $script:xmlContent = Get-Content -Path 'xml\array.xml' -Raw
    }

    Context "test the object properties" {
        it "test the arrayNode properties"{ 
        $xml = [xml]$script:xmlContent
        $nodes = $xml.DocumentElement.ChildNodes

        # Expect three top-level element nodes
        $nodes.Count | Should -Be 3

        # Use the requested path for node count
        $objectNode = ($xml.objects.object[1])

        # Count the <value> nodes under .property.array
        ($objectNode).property.array.value.Count | Should -Be 5

     
    }
    }
    Context "test the rehydration code functionality"   {
        It 'test if the array += working' {
            $xml = [xml]$script:xmlContent
            $arrayObject_new = @()
            foreach ($valueNode in ($xml.objects.object[1]).property.array.value) {
                $arrayObject_new += [int]($valueNode."#text")
            }

            $arrayObject_new | Should -Be @(1,2,3,4,5)
        }
    }
}