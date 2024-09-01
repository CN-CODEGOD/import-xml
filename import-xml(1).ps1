function import-xml {
    param([System.Xml.XmlElement]$object)
    if (($null -ne $object ) -and ($null -ne $object.property)){

        $psobject = new-object pscustomobject
        foreach ($property in @($object.property)){

            if ($property.property.name -like 'property'){
                $psobject |add-Member noteproperty $property.name ($property.property| % {import-xml $_})

            }
            else{
                if ($null -ne $property.'#text'){
                    $psobject |add-Member noteproperty  $property.name  $property.'#text'
                }
                else {
                    if ($null -ne $property.name ){

                        $psobject |add-Member noteproperty $property.name (import-xml $property)
                    }
                }
            }
        }
        $psobject
    }
}




          $xml=cat "C:\Users\34683\import-xml(1)\import-xml\convertto-xml.template.md"
        
$object = import-xml ([xml]$xml).objects.object
     
        
        
        $object