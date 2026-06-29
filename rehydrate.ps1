
<#

pws
#>
function rehydrate([System.Xml.XmlElement]$dehydrated_object) {
        if (( $null -ne $dehydrated_object) -and ($null -ne $dehydrated_object.property)) {
            $intializePsobject = New-Object pscustomobject

            foreach ($property in $dehydrated_object.property) {
               <#
               
               
               #> if ( $property.property.name -eq 'property') {
                    $intializepsobject | Add-Member NoteProperty  -name $property.name -Value ($property.property | % { rehydrate $_ })
                }
                elseif($null -ne $property.hashtable){
$hashobject=@{}
($property.hashtable.key).foreach{
    $hashobject.($_.name)=$_."#text"
}
$intializePsobject|add-member Noteproperty -Name $property.name -Value $hashobject 
} 


                

                elseif($null -ne $property.array){
  $arrayObject_new = @()
            foreach ($valueNode in $property.array.value) {
                $arrayObject_new += [int]($valueNode."#text")
            }

$intializePsobject |add-member noteproperty -Name $property.name -Value $arrayObject
                }

                elseif($null -ne $property.scriptblock){
                    $scriptblockObject ={$property.scripblock."#text"}
                    
                    $intializePsobject |add-member noteproperty -Name $property.name -Value $scriptblockObject
                }
                elseif ($null -ne $property.'#text') {
                    $intializePsobject | Add-Member NoteProperty -name $property.name -Value $property.'#text'
                }
                else {
                    
                    if($null -ne $property.name -and $property.property){
                        $intializePsObject|add-member noteproperty -name $property.name -Value (rehydrate $property)
                    }

                    else {

                       $intializepsobject | Add-Member NoteProperty -name $property.name -Value $null

                    }
                    
                        
                    
                }
            }
    
         
            $intializepsobject
        }
    
    }