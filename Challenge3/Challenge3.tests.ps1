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
#$Dir = "E:\GitHub\Cloud\IronScripter\Challenge3

$PreviousWarningPreference = $WarningPreference
$WarningPreference = 'SilentlyContinue'

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

        it 'ComputerName should accept pipeline' {
            #Test without param, with array, with pipeline with propertyname
            {"localhost","$env:COMPUTERNAME" | Get-DiskInfo} | Should -not -Be $null  
        }

        it 'Drive K should generate error' {
            #Test without param, with C, with e, with H, z
            {Get-DiskInfo -Drive 'K'} | Should -Throw   
        }

        it 'Drive u should generate error' {
            #Test without param, with C, with e, with H, z
            {Get-DiskInfo -Drive 'u'} | Should -Throw   
        }

        it 'Drive e should work' {
            #Test without param, with C, with e, with H, z
            {Get-DiskInfo -Drive 'c'} | Should -not -Be $null   
        }
    }

    Context 'Properties...' {
        #Should return an object with all properties
        #Should not generate a logfile

        $DiskInfo = Get-DiskInfo
        
        $DynProps = $DiskInfo | gm | Where-Object{$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Name
        Foreach ($Prop in $DynProps) {
            it "Function test property: $prop" {

                $($DiskInfo.$prop) | Should -not -Be $null
            }
        }  

        it 'Function SizeGB is [int]' {
           {$Diskinfo.SizeGB.GetType() -eq [int]}  | Should -Be $true
        } 
    }

    Context 'Test log errors' {
       #Validate the error output
       #Validate log
            #Date format
            #Not empty  
            
       #After context exist? >> remove logs after test
       BeforeAll {
            $filename = "{0}_DiskInfo_Errors.txt" -f (Get-Date -format "yyyyMMddhhmm")
       } 


       it "Error should not be generated" {
            #Should not throw
            $errorLog = Join-Path -path $Dir -ChildPath $filename 
            Get-diskInfo -LogPath $Dir | out-null
            Test-Path -Path $errorLog | Should -Be $false    
        }
        
        it 'Error should be generated' {
            $errorLog = Join-Path -path $Dir -ChildPath $filename 
            Get-diskInfo -LogPath $Dir -Computername localblahhost
            Test-Path -Path $errorLog | Should -Be $true 
            Remove-Item $errorLog
        }    

        $WarningPreference = $PreviousWarningPreference
    }
}
