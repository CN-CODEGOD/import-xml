

  
Describe "test the test.class.ps1"{

      BeforeAll {

        #load class.ps1
       # . $psscriptroot/class.ps1
        #load test.class.ps1
        . "O:\OneDrive\.modules\import-xml\test.class.ps1"
    }
    beforeEach {
        

        $nestedPscustomobject = [PSCustomObject]@{
            testInstance = [PSCustomObject]@{
                name = "default name"
                text = "default text"
            }
            text = "text"
        }


        $hashtablePsCustomObject=@([PSCustomObject]@{
    hash = @{key1 = "value1"; key2 = "value2"}
    text = "custom text"
            })

            $arrayPsCustomObject=@(
        [PSCustomObject]@{
            array = @(1, 2, 3)
            text = "text"
        }
    )

    $scriptblockPsCustomObject=@([PSCustomObject]@{
                scriptblock = {Write-Host "Hello, World!"}
                text = "text"})

    }
context "nestedInstanceTest" {
    
    it 'Test the Pscustomobject Doinit method'{
        #$object =new-object -typename "nestedInstance" -ArgumentList $nestedPscustomobject
        $nestedPscustomobject|should -not -BeNullOrEmpty
        $object=[nestedInstance]::new($nestedPscustomobject)
       # $object |should -beoftype "nestedInstance" 
        $object.text|should -be "text"
        $object.testInstance.name|should -be "default name"
        $object.testInstance.text|should -be 'default text'
    }

}
Context "hashtableInstanceTest" -skip{

    it 'test the void constructor' -skip{

    }

    it 'test the Pscustomobject doinit method'{


    }


}

Context "scriptblockInstancTest" -skip {

    it 'test the void constructor'{


    }

    it 'test the Pscustomobject doinit method'{


    }
}

Context "arrayInstanceTest" -skip{

    it 'test the void Contructor'{

    }
    it 'test the Pscustomobject doinit method'{


    }
}

}