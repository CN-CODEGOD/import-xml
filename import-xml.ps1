
        . c:\Users\34683\BFS\graph.class.ps1;
         . "C:\Users\34683\BFS\gps.class.ps1";
         . "C:\Users\34683\BFS\graph.ps1"
function import-xml([xml]$xml){



foreach ($object in $xml) {
    
getobject $object

  
}


}


function getobject($object,$currentobject,$inputproperties=@{}) {
    
$global:object=$object
               $object|ForEach-object{

  if ($currentobject=$null) {
            $currentobject = $object
            
        }

        
        foreach($currentProperty in $currentobject){ 
        







$inputproperty[$currentProperty.name]= rehydrate -currentobject $currentProperty -inputproperty $inputproperty

        }
                                 
        
}
}


function rehydrate($property,[0]$inputproperty){


    $a=New-Object array
    $object=New-Object $property.type
    $inputproperties = new-object System.Collections.Hashtable
if ($property.Value) {
foreach($value in $property){
    $a.add($value)
    
}
   $a = $a-join ","
   Invoke-Expression '$object=($a) '
   $object
}

elseif ($property.NoteProperty) {
    $psobject = New-Object $property.type
    foreach($noteproperty in $property){

        $psobject|Add-Member $noteproperty.name $noteproperty.innertext
    }
    $psobject
}
elseif ($property.key) {

    $hashtable =New-Object $property.type

    foreach ($key in $property) {
        $hashtable[$key.name]=$key.innertext

    }
}
else {
 

$inputproperty.add


}

    }
      




