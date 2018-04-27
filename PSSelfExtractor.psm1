# Add Functions
Get-ChildItem -Path "$PSScriptRoot\cmds" -Filter "*ps1" | ForEach-Object {
	. $PSItem.FullName
	Export-ModuleMember -Function $PSItem.BaseName
}