

    
    
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


function rehydrate([System.Xml.XmlElement]$object) {
    if (($object -ne $null) -and ($null -ne $object.property)) {
        $psobject = New-Object pscustomobject
        
        foreach ($property in $object.property) {
            if ($property.property.name -eq 'property') {
                $psobject | Add-Member NoteProperty $property.name ($property.property | % { rehydrate $_ })
            }
            elseif ($property.Value) {
                $a = @()
                foreach ($value in $property.value) {
                    $a += $value
                }
                $psobject | Add-Member NoteProperty $property.name $a
            }
            elseif ($property.key) {
                $hashtable = @{}
                foreach ($key in $property.key) {   
                    $hashtable[$key.name] = $key.innertext
                }
                $psobject | Add-Member NoteProperty $property.name $hashtable
            }
            elseif ($null -ne $property.'#text') {
                $psobject | Add-Member NoteProperty $property.name $property.'#text'
            }
            else {
                if ($null -ne $property.name -and $property.property) {
                    $psobject | Add-Member NoteProperty $property.name (rehydrate $property)
                }
                else {
                    $psobject | Add-Member NoteProperty $property.name $null
                }
            }
        }
        
        $psobject
    }
}
function Import-Xml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )

    try {
        [xml]$xml = Get-Content -Path $Path -ErrorAction Stop
        
        foreach($object in $xml.objects.object) {
            $objectType = $object.type
            if ([string]::IsNullOrEmpty($objectType)) {
                Write-Warning "Object type not specified in XML"
                continue
            }

            try {
                $instance = New-Object -TypeName $objectType -ErrorAction Stop
                $pscustomObject = rehydrate $object
                $instance.doinit($pscustomObject)
                $instance
            }
            catch {
                Write-Error "Failed to create instance of type '$objectType': $_"
            }
        }
    }
    catch {
        Write-Error "Failed to process XML file '$Path': $_"
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
        
        $xmlsettings=new-object system.xml.xmlwritersettings
        $xmlsettings.indent=$true
        $xmlwriter=[system.xml.xmlwriter]::Create($object.path,$xmlsettings)
        $xmlwriter.writestartelement("objects")
        $xmlwriter.flush()
        $xmlwriter.close()
        write "创建新xml 表"
    }

    $doc.load($object.path)
    $newnode= $doc.CreateDocumentFragment()
    
    if ($doc.DocumentElement.LastChild -ne $null) {
        $id= [int]($doc.DocumentElement.LastChild.Attributes["id"].Value) + 1
    } else {
        $id = 1
    }

    $attributeid=$doc.CreateAttribute("id")
    $attributeid.Value=$id
    $newnode.InnerXml=$object.save()
    $doc.DocumentElement.appendchild($newnode)
    $nodeelement = $doc.DocumentElement.LastChild
    $nodeelement.attributes.append($attributeid)
    $doc.Save($object.path)
}
    
  
    function export-object {
        [CmdletBinding()]
        param (
            [Parameter()]
            [object]
            $objects 
            ,
            # Parameter help description
            [Parameter()]
            [string]
            $Path)
            $doc=New-Object System.Xml.XmlDocument
            del $path

            $xmlsettings=new-object system.xml.xmlwritersettings
            $xmlsettings.indent=$true
            $xmlwriter=[system.xml.xmlwriter]::Create($path,$xmlsettings)
            $xmlwriter.writestartelement("objects")
            $xmlwriter.flush()
            $xmlwriter.close()
            write "创建新xml 表"      
  foreach ($object in $objects) {
            $doc.load($path)
            $newnode= $doc.CreateDocumentFragment()
            
            $id= [int]($doc.objects.LastChild.id) + 1
       
        
            $attributeid=$doc.CreateAttribute("id")
            $attributeid.Value=$id
            $newnode.InnerXml=$object.save()
            $doc.DocumentElement.appendchild($newnode)
            $nodeelement = $doc.objects.LastChild
            $nodeelement.attributes.append($attributeid)
    
    
    
    
            $doc.Save($path)
            write "成功添加"
            
        }
    
    
    
        
        
    }
    function test-class($object) {
        try {
            save-object $object 
            "sucess"
        }
        catch {
        Write-Error "$error"
        }
       
        
        try {
            import-xml $object.path 
            "success"
        }
        catch {
            Write-Error $error
        }
    }


    function xml-csv {
      
param($Path,$literalpath)

$object =import-xml $Path
export-csv $object -LiteralPath $literalpath


        
    }

    function csv-xml {
    param($path,$literalpath)    
    



     


 # 获取表头（列名）
$headers = $csv[0].PSObject.Properties.Name

# 输出列名

#创建xmlDocument[]
$xml=[xml]::new()

foreach($csvColum in $csv){
    #创建新element
    $newelement=$xml.CreateElement("object")
    
$xml=
    foreach($head in $headers){

   

    }
#生成object



}



        
    }