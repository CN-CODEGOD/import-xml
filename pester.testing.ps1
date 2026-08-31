. $PSScriptRoot/rehydrate.ps1
. $PSScriptRoot/dummyfunction.ps1

describe "test the pester behavior " {
    BeforeAll {
        mock rehydrate { return @(
            [PSCustomObject]@{
                testInstance = @{
                    name="default name"
                    txt="default text"
                }
                text = "text"
            }
        )

            
        }

        function dummyfunction {
            #invoke rehydrate to test if the mock is working
            rehydrate
            
        }
    }
    it "test if mocking rehydrate successfully" {
        rehydrate | Should -Not -BeNullOrEmpty
        rehydrate | Should -BeOfType "PSCustomObject"
        $rehydrate=rehydrate
        $rehydrate.testInstance | Should -Not -BeNullOrEmpty
        $rehydrate.testInstance.name | Should -Be "default name"
        $rehydrate.testInstance.txt | Should -Be "default text"
        $rehydrate.text | Should -Be "text"


    }
    it 'test if the mock works in other function' {
        dummyfunction | Should -Not -BeNullOrEmpty
        dummyfunction | Should -BeOfType "PSCustomObject"
        $dummyfunction=dummyfunction
        $dummyfunction.testInstance | Should -Not -BeNullOrEmpty
        $dummyfunction.testInstance.name | Should -Be "default name"
        $dummyfunction.testInstance.txt | Should -Be "default text"
        $dummyfunction.text | Should -Be "text"

    }
    it 'test if the mock works in other scriptfile' {

dummyScript | Should -Not -BeNullOrEmpty
        dummyscript | Should -BeOfType "PSCustomObject"
        $dummyscript=dummyscript
        $dummyscript.testInstance | Should -Not -BeNullOrEmpty
        $dummyscript.testInstance.name | Should -Be "default name"
        $dummyscript.testInstance.txt | Should -Be "default text"
        $dummyscript.text | Should -Be "text"
    }

    
}