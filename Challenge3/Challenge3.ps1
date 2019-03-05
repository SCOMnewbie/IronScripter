#https://ironscripter.us/iron-scripter-2019-prelude-challenge-2/

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

#return "Nope still no F5"

Function Get-DiskInfo {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $false,
                    ValueFromPipeline = $true)]
        [string[]]$Computername = $env:COMPUTERNAME,
        [ValidatePattern("[A-G|a-g]")]
        [string]$Drive = "C",
        #[string]$LogPath = $env:temp
        [string]$LogPath = 'C:\Github\IronScripter\Challenge3'
    )
    Begin {
        Write-Verbose "Starting $($myinvocation.mycommand)"
        $filename = "{0}_DiskInfo_Errors.txt" -f (Get-Date -format "yyyyMMddhhmm")
        $errorLog = Join-Path -path $LogPath -ChildPath $filename

        $Drive = $($Drive.toUpper())
    }
    Process {
        foreach ($computer in $computername) {

            Write-Verbose "Getting disk information from $computer for drive $($drive.toUpper())"
            try {

                Write-Verbose "Try to connect on computer: $computer"
                $CimSession = New-CimSession -ComputerName $computer -ErrorAction SilentlyContinue
                if(! $CimSession){
                    write-warning "Unable to connect on computer: $computer"
                }
                $data = Get-Volume -DriveLetter $drive -CimSession $CimSession -ErrorAction stop| Select  DriveLetter,
                @{Name="SizeGB";Expression = {$_.Size/1GB -as [int]}},
                @{Name="FreeGB";Expression = {$_.SizeRemaining/1GB}},
                @{Name="PctFree";Expression = {($_.SizeRemaining/$_.size*100 -as [int])}},
                HealthStatus,
                @{Name = "Computername";Expression = {$($_.PSComputername.toUpper())}} 
            }
            catch {
                Add-Content -path $errorlog -Value "[$(Get-Date)] Failed to get disk data for drive $drive from $computername"
                Add-Content -path $errorlog -Value "[$(Get-Date)] $($_.exception.message)"
                $newErrors = $True
            }

            $data
            #Force Cim disconnect
            Get-CimSession -ComputerName $computer -ea SilentlyContinue | Remove-CimSession -ErrorAction SilentlyContinue
        }
    }
    End {
        If ((Test-Path -path $errorLog) -AND $newErrors) {
            Write-Warning "Errors have been logged to $errorlog"
        }

        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}

