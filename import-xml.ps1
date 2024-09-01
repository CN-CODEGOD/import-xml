


         
function import-xml($path){
[xml]$xml=cat $path
foreach($object in $xml.objects){
new-object -typename $object.type -argumentlist (rehydrate $object)
}

}

function rehydrate([System.Xml.XmlElement]$object){
    if (($object -ne $null) -and ($null -ne $object.property )){
        $psobject =new-object pscustomobject 
    foreach ($property in $object.property){

 

        




          if ($property.property.name -like 'property'){
                $psobject |add-Member noteproperty $property.name ($property.property| % {rehydrate $_})

            }
            else{ <#
              if ($null -ne $property.'#text'){
                    $psobject |add-Member noteproperty  $property.name  $property.'#text'
                }
            #>
              ##array
                if ($property.Value) {
$a=@()
    

    
foreach($value in $property.value){
    $a+=$value
}
$psobject|add-member noteproperty $property.name $a
}

#hashtable
elseif ($property.key) {

    $hashtable =New-Object $property.type

    $hashtable = foreach ($key in $property) {
        $hashtable[$key.name]=$key.innertext

    }
    $psobject|add-Member $property.name $hashtable
}
       elseif ($null -ne $property.'#text'){
                    $psobject |add-Member noteproperty  $property.name  $property.'#text'
                }

                else {
                    if ($null -ne $property.name ){

                        $psobject |add-Member noteproperty $property.name (rehydrate $property)
                    }
                }
            }


      

}




            
        

  
   
    }
      
    $psobject
    }









                                 
        








      




