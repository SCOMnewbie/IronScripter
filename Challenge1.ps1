
function Convert-MyCounter {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] 
        [Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSampleSet]$CounterSample
    )

    #Process block to manage all $CounterSample
    PROCESS {
        foreach ($Item in $CounterSample.CounterSamples) {
            #Fun stuff appears like \\ when remote machine let's sanatize
            $NewPath = $Item.Path.Tostring().replace('\\', '\')
            $Object = New-Object PSCustomObject -Property @{            
                ComputerName = $NewPath.split('\')[1]                 
                CounterSet   = $NewPath.split('\')[2]  
                Timestamp    = $Item.Timestamp          
                Counter      = $NewPath.split('\')[3]            
                Value        = $Item.cookedvalue                      
            }   
            $Object
        } 
    }
}

#Works
$var = Get-Counter
$var | Convert-MyCounter
Convert-MyCounter $var 
get-counter | Convert-MyCounter

#works
$var1 = Get-Counter
$var2 = Get-Counter
$var1, $var2 | Convert-MyCounter
Convert-MyCounter $var1, $var2

#works
get-counter -MaxSamples 2 | Convert-MyCounter

#works
Get-counter -ComputerName localhost | Convert-MyCounter

#works
Get-counter -MaxSamples 2 -ComputerName locahost | Convert-MyCounter

