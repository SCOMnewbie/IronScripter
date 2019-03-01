<#

This function should get disk information from one or more computers. It should accept computer names via a parameter and from the pipeline and should only get a drive C through G. Errors should be logged to a text file with a file name that includes a timestamp value in the form YearMonthDayHourMinute.

For non-North Americans feel free to adjust the date time format in the function and Pester tests.

Correct output should look like this:

DriveLetter : C
SizeGB : 123
FreeGB : 110,4324
PctFree : 91
HealthStatus : Healthy
ComputerName : S4


#>
$Dir = "C:\Github\IronScripter\Challenge3"
Set-Location $Dir
#Remove-Item -Path Function:\Get-DiskInfo -Force -ErrorAction SilentlyContinue
. "$dir\Challenge3.ps1"

Describe "Function: Get-DiskInfo" {

    

    Context 'Parameters...' {
        
        
        $Command = get-command Get-DiskInfo


        it 'ComputerName should be an array' {
            #Test without param, with array, with pipeline with propertyname
            $command.Parameters.Computername.ParameterType.BaseType.Name | Should -Be 'Array'  
        }

        it 'Drive K should generate error' {
            #Test without param, with C, with e, with H, z
            $ProjectNameMG.Name | Should Throw  
        }
    }

    <#

    Context 'Test function with good parameters...' {
        #Should return an object with all properties
        #Should not generate a logfile
        
        it 'Test Get-DiskInfo property...' {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $($ProjectNameSub.Name) | Should -BeExactly $SubName 
        }

        it "Is Subscription Dev exist under MG: $ProjectName" {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.ParentName -eq $ProjectName) -AND ($_.Name -eq $SubName)}
            $ProjectNameSub | Should -Not -BeNullOrEmpty 
        }    
    }

    

    Context 'Test function with bad drive...' {
        
         it "Test date format" {
            ##################################
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $ProjectNameSub.Name | Should -Not -BeNullOrEmpty
        }

        it "Test date format" {
            ##################################
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $ProjectNameSub.Name | Should -Not -BeNullOrEmpty
        }
        
        it 'Test Get-DiskInfo property...' {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $($ProjectNameSub.Name) | Should -BeExactly $SubName 
        }

        it "Is Subscription Dev exist under MG: $ProjectName" {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.ParentName -eq $ProjectName) -AND ($_.Name -eq $SubName)}
            $ProjectNameSub | Should -Not -BeNullOrEmpty 
        }    
    }

    Context 'Test function with bad computername...' {
       #Validate the error output
       #Validate log
            #Date format
            #Not empty
            
       #After context exist? >> remove logs after test 

       it "Test date format" {
            ##################################
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $ProjectNameSub.Name | Should -Not -BeNullOrEmpty
        }
        
        it 'Test Get-DiskInfo property...' {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.type -eq "Subscription") -AND ($_.Name -eq $SubName)}
            $($ProjectNameSub.Name) | Should -BeExactly $SubName 
        }

        it "Is Subscription Dev exist under MG: $ProjectName" {
            $SubName = "Sub-$ProjectName-Dev"
            $ProjectNameSub = $MGInfos | Where-Object {($_.ParentName -eq $ProjectName) -AND ($_.Name -eq $SubName)}
            $ProjectNameSub | Should -Not -BeNullOrEmpty 
        }    
    }
    #>
}
