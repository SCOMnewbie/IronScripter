
function Get-InstalledFeature
{
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ComputerName

    )
    
    $sb = {Dism.exe /online /Get-Features}

    if($ComputerName){
        $text = Invoke-Command -ComputerName $ComputerName -ScriptBlock $sb
    }
    else{
        $text = Invoke-Command -ScriptBlock $sb
    }
    
    #Remove the header and the footer we don't want. I suck in regex but it does what I want lol.
    $text = $text | Select-String -Pattern "Feature Name :\s(\w+)|State :\s(\w+)"
    #Let's put the feature with the state on the same line (it will help for the match after)

    $FeaturesInstallationState = @()
    for ($i = 0; $i -lt $text.count; $i = $i + 2) {
        $Feature = $text[$i].Tostring().replace('Feature Name : ', '')
        $Name = $text[$i + 1].ToString().replace('State : ', '')

        $Obj = [PSCustomObject] @{
            FeatureName = $Feature
            State  = $Name
        }

        $FeaturesInstallationState += $Obj
    
    }
    
    return $FeaturesInstallationState
}

$Baseline = Get-InstalledFeature
$remoteStatus = Get-InstalledFeature -ComputerName JEA-01

#We just take one side
$Differences = Compare-Object -ReferenceObject $baseline -DifferenceObject $remoteStatus -Property FeatureName,State | Where-Object {$_.SideIndicator -eq '=>'}

Foreach($Difference in $Differences){
    if($Difference.State -eq "Disabled"){
        $Action = 'Enable'
    }
    else{
        $Action = 'Disable'
    }

    Invoke-Command -ComputerName JEA-01 -Scriptblock {
        param ($Feature, $Action)
        if($Action -eq 'Disable'){
            Dism /online /$Action-Feature /FeatureName:$Feature /quiet
        }#Disabling
        else{
            Dism /online /$Action-Feature /FeatureName:$Feature /quiet /all
        }#Installing
        
    } -Args $Difference.FeatureName, $Action
}

#Works but has some issue when the machine will reboot. Can we try workflow instead?