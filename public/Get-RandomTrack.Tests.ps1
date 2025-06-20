
# TASK 3: in here we start testing differently, we will identify a public api of our module, the current function.
# and we will identify a seam at the other side of the module. This will give us a simple way to isolate the function
# from "random" outside world.
#
# We will test the public api, meaning that we have easy time doing the same what our users do, or what our users reported.
# When we are not able to repro the problem, then is it worth testing it? 


Describe "Get-RandomTrack" {
    BeforeAll {
        # 1. We need to replace this with importing the module, we force import so we don't have to care about
        # importing other functions used by this function. And it also aligns well with our goal to test the public api.
        # . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

        Import-Module $PSScriptRoot\..\Runner.psm1 -Force
    }
    
    # 2. In this test we will have to put together all our knowledge of Mocking. 
    # - introduce a default Mock, that will throw, so we prevent ourselves from calling the real api.
    It -Name 'Gets the provided track when there is just one' {
        # 1. this code and the call below. run it and observe that we throw.
        # What if we don't specify -ModuleName?
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner

        # 2. add this but there are more calls, so we debug the function to see if the first mock does what we want.
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        } -ModuleName Runner


        # 3. Then write another mock for the ratings. Don't 
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] @{
                trackId = 123
                rating  = 4.5
            }
        } -ModuleName Runner
        
        # and this code for 1.
        $actual = Get-RandomTrack -Length 9 -Difficulty easy

        # 4. Ensure that we got the object with formats that we expect.
        $actual.Name | Should -Be "John's Trail"
        $actual.TrackId | Should -Be 123
        $actual.Difficulty | Should -Be 1
        $actual.Length | Should -Be 9
        $actual.Gpx | Should -Be "<gpx>...</gpx>"
        $actual.Rating | Should -Be 4.5
    }

    # TASK 4 - introduce the mile bug and write test for it using mock validation.
    # The bug is that we assign the $Length value too late, so even thought we tested the convertto-km function we don't use it basically.
    It -Name 'Gets the provided track when there is just one' {
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner
    
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] @{
                trackId = 123
                rating  = 4.5
            }
        } -ModuleName Runner
        
        # and this code for 1.
        $null = Get-RandomTrack -Length 9 -Difficulty easy -Unit mi
         
        Should -Invoke Invoke-RestMethod -ParameterFilter { $Uri -like "*length=14.48406*" } -ModuleName Runner
    }


    # TASK 5 - now we want to write test for random, and we might be tempted to mock and should-invoke again.
    # but that is not good idea (usually). 
    # compare the case with get-random, there are 2 approaches, option 1 is replacing get random and checking that we called it.
    # this is not great.
    # Option 2 shows that we focus on the public api and try to approximate the behavior. When we have call to get random,
    # if we call the function 10 times with the same parameters then we should get all the possible values.
    It -Name 'Gets random track when there are multiple tracks (option 1)' {
        # Mocks that make sure the module works
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] @{
                trackId = 123
                rating  = 4.5
            }
        } -ModuleName Runner

        # Mock that we test
        Mock -CommandName Get-Random -MockWith {
            $InputObject
        } -ModuleName Runner

        $actual = Get-RandomTrack -Length 9 -Difficulty easy
        $actual.Name | Should -Be "John's Trail"

        Should -Invoke -CommandName Get-Random -Exactly 1 -ModuleName Runner -ParameterFilter { $InputObject.TrackId -eq 123 }
    }

    It -Name 'Gets random track when there are multiple tracks (option 2)' {
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner
        
        $exampleTrack = @(
            @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
            @{
                trackId         = 124
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail 2"
            }
            @{
                trackId         = 125
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail 3"
            }
        )

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] $exampleTrack
        } -ModuleName Runner


        $exampleRating = @(
            @{
                trackId = 123
                rating  = 4.5
            }
            @{
                trackId = 124
                rating  = 4.5
            }
            @{
                trackId = 125
                rating  = 4.5
            }
        )

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] $exampleRating
        } -ModuleName Runner
        
        $actual = 1..20 | ForEach-Object { 
            Get-RandomTrack -Length 9 -Difficulty easy 
        } | Select-Object -ExpandProperty TrackId | Sort-Object -Unique

        Write-Host "Actual: $($actual -join ', ')"
        $actual.Count | Should -Be 3 -Because "we are getting random tracks, and with enough tries we should see all our example tracks being randomly selected"
    }

    # TASK 6: implement the check for throw, you will need a mock and Should -Throw
    It "throws when no tracks are found" {
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            @() # no tracks found
        } -ModuleName Runner

        { Get-RandomTrack -Length 9 -Difficulty easy } | Should -Throw "No routes found matching the criteria."
    }
}