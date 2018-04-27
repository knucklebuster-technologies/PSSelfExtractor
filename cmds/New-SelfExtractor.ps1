
<#
	.SYNOPSIS
		Create a new self extracting zip.
	.DESCRIPTION
		This function takes 2 mandatory params path and destination.
		Path is the folder structure to turn into SE.
		Destination is the path to place the SE
	.PARAMETER  Path
		the folder or file path of the struture that will generate a SE.
		the Path must exist
	.PARAMETER Destination
		the Destination path to write the SE.
		The path needs to include the filename to be created SomeSE.exe
	.PARAMETER SelfExtractorOption
		Ionic.Zip.SelfExtractorSaveOptions object like that returned by New-SelfExtractorOption.
	.EXAMPLE
		PS C:\> New-FPSelfExtractor -Path 'C:\Dev\Module\Log' -Destination 'C:\Dev\Packages\Log.exe' -SelfExtractorOption $Options
	.NOTES
		do not write to network paths it will fail. create the SE on the local filesystem then copy out to a drop.
#>
function New-SelfExtractor {
	[CmdletBinding()]
	param(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[ValidateScript({
		if( Test-Path $PSItem ) { return $true }
		throw "The path $PSItem does not exist"
	})]
	[string]
	$Path,

	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[ValidateScript({
		if ("$PSItem".EndsWith('.exe')) { return $true }
		throw 'The Destination must include the file name ending with .exe'
	})]
	[string]
	$Destination,

	[Parameter(Mandatory)]
	[ValidateNotNull()]
	[Ionic.Zip.SelfExtractorSaveOptions]
	$SelfExtractorOption
	)

	$DestDir = Split-Path $Destination -Parent
	if( -not ( Test-Path $DestDir)) {
		[System.IO.Directory]::CreateDirectory($DestDir)
	}
	if( Test-Path "$Destination" ){
		Remove-Item "$Destination" -Force
	}

	$Zip = New-Object Ionic.Zip.ZipFile
	$Zip.AddItem("$Path")
	$Zip.SaveSelfExtractor("$Destination", $SelfExtractorOption)
}