#Remove all crap on top of the file and create object
#$Text = &{Dism.exe /online /Get-Features} | Select-Object -Skip 8 | Select-String -Pattern "^(\w\s\w\s:\s)"
#$Text = Get-Content C:\test.txt -Raw


#Feature Name : Microsoft-Windows-Subsystem-Linux
#State : Disabled

#" 42,Answer" | Select-String -Pattern '^\s+(\d+),(.+)'


Set-Content test.txt -value @"
Feature Name : LegacyComponents
State : Disabled

Feature Name : DirectPlay
State : Enabled

Feature Name : SimpleTCP
State : Joker

"@

Get-ChildItem test.txt | 
    Select-String -Pattern "Feature Name :\s(\w+)|State :\s(\w+)" |
    Foreach-Object {
    $Feature, $State = $_.Matches[0].Groups[1..4].Value   # this is a common way of getting the groups of a call to select-string
    [PSCustomObject] @{
        FirstName        = $first
        LastName         = $last
        Handle           = $handle
        TwitterFollowers = [int] $followers
    }
}

& {Dism.exe /online /Get-Features} | Select-Object -Skip 8 | Select-String -Pattern "Feature Name :\s(.+)|State :\s(.+)" | 
    Foreach-Object {
    $Feature, $State = $_.Matches[0].Groups[1..2].Value
    [PSCustomObject] @{
        Feature = $Feature
        State   = $State
    }
}

for ($i = 0; $i -le $var.count; $i = $i + 2) {
    $Feature = $var[$i].Tostring().replace('Feature Name : ', '')
    $Name = $var[$i + 1].ToString().replace('State : ', '')
    Write-output "OK $Feature, $Name"
}

$Baseline.count

$Baseline.matches[0].groups[1].value

$Text = & {Dism.exe /online /Get-Features} | Select-Object -Skip 8 | Select-String -Pattern "Feature Name :\s(\w+)|State :\s(\w+)"

$result = for ($i = 0; $i -lt $var.count; $i += 2) {$var[$i]}

<#
PS E:\GitHub\Cloud\IronScripter> $var.matches[0].groups[1].value
LegacyComponents
PS E:\GitHub\Cloud\IronScripter> $var.matches[1].groups[2].value
Disabled
PS E:\GitHub\Cloud\IronScripter> $var.matches[2].groups[1].value
DirectPlay
PS E:\GitHub\Cloud\IronScripter> $var.matches[3].groups[2].value
Enabled
PS E:\GitHub\Cloud\IronScripter> $var.matches[4].groups[1].value
SimpleTCP
PS E:\GitHub\Cloud\IronScripter> $var.matches[5].groups[2].value

#>
$var = & {Dism.exe /online /Get-Features} | Select-Object -Skip 8 | Select-String -Pattern "Feature Name :\s(\w+)|State :\s(\w+)"
Feature Name : LegacyComponents
State : Disabled
Feature Name : DirectPlay
State : Disabled
Feature Name : SimpleTCP
State : Disabled
Feature Name : SNMP
State : Disabled
Feature Name : WMISnmpProvider
State : Disabled
Feature Name : LegacyComponents
State : Disabled
Feature Name : DirectPlay
State : Disabled
Feature Name : SimpleTCP
State : Disabled
Feature Name : SNMP
State : Disabled
Feature Name : WMISnmpProvider
State : Disabled

PS C:\WINDOWS\system32> for ($i = 0; $i -le $var.count; $i = $i + 2) {
    >>     $Feature = $var[$i].Tostring().replace('Feature Name : ', '')
    >>     $Name = $var[$i + 1].ToString().replace('State : ', '')
    >>     Write-output "OK $Feature, $Name"
    >> }

    
