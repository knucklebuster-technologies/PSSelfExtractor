# Add Modules
Get-ChildItem -Path "$PSScriptRoot\modules" | ForEach-Object {
	Import-Module $($PSItem.FullName) -Force
}

# Add Variabes
Get-ChildItem -Path "$PSScriptRoot\vars" -Filter "*ps1" | ForEach-Object {
	. $PSItem.FullName
	Export-ModuleMember -Variable $PSItem.BaseName
}

# Add Functions
Get-ChildItem -Path "$PSScriptRoot\cmds" -Filter "*ps1" | ForEach-Object {
	. $PSItem.FullName
	Export-ModuleMember -Function $PSItem.BaseName
}