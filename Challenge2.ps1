return "Hi there !"

#region Generate local Baseline

$sb = {Dism.exe /online /Get-Features}
$text = Invoke-Command -ScriptBlock $sb
#Remove the header and the footer we don't want. I suck in regex but it does what I want lol.
$text = $text | Select-String -Pattern "Feature Name :\s(\w+)|State :\s(\w+)"
#Let's put the feature with the state on the same line (it will help for the match after)

$baseline = @()
for ($i = 0; $i -lt $text.count; $i = $i + 2) {
    $Feature = $text[$i].Tostring().replace('Feature Name : ', '')
    $Name = $text[$i + 1].ToString().replace('State : ', '')

    $Obj = [PSCustomObject] @{
        FeatureName = $Feature
        State  = $Name
    }

    Write-output "$Feature, $Name"
    $Baseline += $Obj
    
}

#endregion

#Now that we jhave the baseline, let's push it to the remote device through winrm

$RemoteComputerName
try{
    $RemoteSession = New-PSSession -ComputerName $RemoteComputerName -ea stop
}
catch{
    Write-Error "Unable to connect on machine: $RemoteComputerName"
}

#Let's start by add features
Foreach($Item in $Baseline){
    Invoke-Command -Session $RemoteComputerName -Scriptblock {
        param ($Feature, $State)
        switch ($State){
            "Disabled" {Dism /online /Disable-Feature /FeatureName:$Feature}
            "Enabled" {Dism /online /Enable-Feature /FeatureName:$Feature}
            Default {Write-warning "Hey we miss something! Check Feature: $Feature with the state: $State"}

        }
    } -Args $Item.feature, $Item.State
}
