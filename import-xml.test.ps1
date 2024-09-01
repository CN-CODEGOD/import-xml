describe import-xml {
    beforeall{
         . c:\Users\34683\BFS\graph.class.ps1;
         . "C:\Users\34683\BFS\gps.class.ps1";
         . "C:\Users\34683\BFS\graph.ps1"
         . "C:\Users\34683\import-xml(1)\import-xml\import-xml.ps1"
    $param4= New-Object PSObject -Property @{
    Name='New'
    Server = 'server'
    Database = 'database'
    UserName = 'username'
    Password = 'password'
}
$param5=[hashtable]@{
  name ='apple'
  type='fruit'
  color='red'
}
$param6=[road]@{
    roadcoordinate=@{

        roadcoordinate1=@{
            x=1
            y=1
            z=1
        }
        roadcoordinate2=@{
            x=1
            y=1
            z=1

        }
    }

    dimension="the_End"
    name=$null
}

function import-xml {
    param([xml]$object)
    if (($object -ne $null ) -and ($object.property -ne $null)){

        $psobject = new-object psobject 
        foreach ($property in @($object.property)){

            if ($property.property.name -like 'property'){
                $psobject |add-Member noteproperty $property.name ($property.property|%{import-xml $_})

            }
            else{
                if ($property.innertext -ne $null){
                    $psobject |add-Member noteproperty  $psobject.name  (import-xml $property)
                }
            }
        }
        $psobject
    }
}

        
    }
    context 'test invoke-expression' {
it'.test value.'{
    $a="1,2,3"
    invoke-expression "[array]($a)"
}
it 'test noteproperty '
    }
    context 'Function'{

        it 'Function'{

            [xml]$xml =cat "C:\Users\34683\import-xml(1)\import-xml\template.md"
            $test = import-xml $xml
            $test|should not be $null
            $test.param1|should be 1 
            $test.param2|should be 2
            $test.param3|should be @(1,2,3)
            $test.param4|should be $param4
            $test.param5|should be $param5
            $test.param6|should be $param6

            
        }
    }
    context 'import-xml'{

it 'test function'{ 
        $object = [psobject]@{
            roadcoordinate=[psobject]@{
                roadcoordinate1=[psobject]@{
                    x=1
                    y=1
                    z=1

                }
                roadcoordinate2=[psobject]@{
                    x=1
                    y=1
                    z=1
            
                }
            }
            dimension='the_end'
            name= $null
        }
        $xml= $object |ConvertTo-Xml
        $object = import-xml -xml $xml
        $object.roadcoordinate|should not be $null
        $object.roadcoordinate.roadcoordinate1|should not be $null
        $object.roadcoordinate.roadcoordinate2|should not be $null
        $object.roadcoordinate.roadcoordinate1.x|should be 1
        $object.roadcoordinate.roadcoordinate1.y|should be 1
        $object.roadcoordinate.roadcoordinate1.z|should be 1
        $object.roadcoordinate.roadcoordinate2.x|should be 1
        $object.roadcoordinate.roadcoordinate2.y|should be 1
        $object.roadcoordinate.roadcoordinate2.z|should be 1
    }
    }
}