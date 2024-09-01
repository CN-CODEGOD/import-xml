function save-object($object){
$doc=New-Object System.Xml.XmlDocument
if(!test-path $object.path){
    $xmlsettings=new-object system.xml.xmlwritersettings
    $xmlsettings.indent=$true
    $xmlwriter=[system.xml.xmlwriter]::Create($object.path,$xmlsettings)
    $xmlwriter.writestartelement("objects")
    $xmlwriter.flush()
    $xmlwriter.close()
    
}

$doc.load($object.path)
$child=$object.save()
$doc.objects.appendchild($child)
$doc.save($object.path)

}