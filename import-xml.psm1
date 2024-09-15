
$paths= $env:classpath -split ";"
# 逐一加载脚本
try {
    $paths|% {. $_}     
}
catch {
    <#Do this if a terminating exception happens#>
}

<#
.SYNOPSIS
import object from xml

.DESCRIPTION
详细描述函数的功能和实现。

.PARAMETER 参数名
--path

.EXAMPLE
演示如何使用此函数的示例代码。

.NOTES
任何其他相关信息，例如作者或版本。

.LINK
https://github.com/CN-CODEGOD/import-xml.git

#>


function rehydrate([System.Xml.XmlElement]$object){
    if (($object -ne $null) -and ($null -ne $object.property )){
        $psobject =new-object pscustomobject 
    foreach ($property in $object.property){

 
        if ($property.property.name -eq 'property'){
            $psobject |add-Member noteproperty $property.name ($property.property| % {rehydrate $_})

        }
                elseif ($property.Value) {
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

                if ($null -ne $property.name -and $property.property  ){

                    $psobject |add-Member noteproperty $property.name (rehydrate $property)
                }
                else {
                    $psobject|Add-Member NoteProperty $property.name $null
                }
            
               
               }
                   
                
               


      

}




            
        

  
   
    }
      
    $psobject
    }
         
function import-xml($path){

[xml]$xml=cat $path
foreach($object in $xml.objects.object){
    New-Object -TypeName $object.type -ArgumentList (rehydrate $object)
}




}








                                 
        








      





<#
.SYNOPSIS
save your object in XML

.DESCRIPTION
save object with save-object 

.PARAMETER 参数名
-path save path

.EXAMPLE
$object |save-object

.NOTES
cn_codegod
.LINK
https://github.com/CN-CODEGOD/import-xml.git

#>

function save-object($object){
    $doc=New-Object System.Xml.XmlDocument


    
    if(!(test-path $object.path)){
      
        try {
        $directory =((get-item ($object.path)).Directory).FullName
         md $directory\xml   
        }
        catch {
            
        }
        $xmlsettings=new-object system.xml.xmlwritersettings
        $xmlsettings.indent=$true
        $xmlwriter=[system.xml.xmlwriter]::Create($object.path,$xmlsettings)
        $xmlwriter.writestartelement("objects")

        $xmlwriter.flush()
        $xmlwriter.close()
        
    }
    
    
        $doc.load($object.path)
        $newnode= $doc.CreateDocumentFragment()
        $newnode.InnerXml=$object.save()
        $doc.DocumentElement.AppendChild($newnode)
        $doc.Save($object.path)
    


    write "成功添加"
    
    

}
    