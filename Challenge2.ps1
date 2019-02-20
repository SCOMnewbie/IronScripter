#Remove all crap on top of the file and create object
#$Text = &{Dism.exe /online /Get-Features} | Select-Object -Skip 8 | Select-String -Pattern "^(\w\s\w\s:\s)"
#$Text = Get-Content C:\test.txt -Raw


#Feature Name : Microsoft-Windows-Subsystem-Linux
#State : Disabled

#" 42,Answer" | Select-String -Pattern '^\s+(\d+),(.+)'


$Text =@"
Feature Name : LegacyComponents
State : Disabled

Feature Name : DirectPlay
State : Disabled

Feature Name : SimpleTCP
State : Disabled

"@

$Text | Select-String -Pattern '^(Feature Name :.+$)|^(State :.+$)' | 
ForEach-Object{
    $Feature, $State = $_.Matches[0].Groups[1..2].value
}