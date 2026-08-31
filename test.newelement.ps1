Describe "test how to add a element" {
    BeforeAll {
$xml=New-Object xml


    }

    context "test newelement" {
        it 'try to create a element with newelement'{
$newelement=$xml.CreateElement("object")

$newelement|Should -BeOfType System.Xml.XmlElement

$newelement.InnerXml|should -not -be $null

        }
        it 'test how to insert innerxml'{
$newelement=New-Object System.Xml.Linq.XmlElement



        }

        it 'test to add multiple elements'{

            $newelement1=New-Object System.Xml.Linq.XElement 
            $xmlnode=[System.Xml.Linq.XNode]::toxmlnode($newelement1)
            $xml.DocumentElement.AppendChild($xmlnode)
            $xml.DocumentElement.AppendChild($xmlnode)
        $xml.DocumentElement|Should -Not -be $null
        
            
        }
    }
}