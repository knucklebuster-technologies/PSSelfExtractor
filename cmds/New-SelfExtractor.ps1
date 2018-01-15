
<#
	.COMPONENT
		FPPackager
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
		Ionic.Zip.SelfExtractorSaveOptions object like that returned by New-FPSelfExtractorOption.
		if not provided a default option set is used.
	.EXAMPLE
		PS C:\> New-FPSelfExtractor -Path 'C:\Dev\Module\Log' -Destination 'C:\Dev\Packages\Log.exe' -SelfExtractorOption $Options
	.INPUTS
		System.String
		System.String
		Ionic.Zip.SelfExtractorSaveOptions
	.OUTPUTS
		null
	.NOTES
		do not write to network paths it will fail. create the SE on the local filesystem then copy out to a drop.
	.LINK
		about_FPPackager_walkthru
#>
function New-FPSelfExtractor {
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true)]
	$Path,
	[Parameter(Mandatory=$true)]
	$Destination,
	[Ionic.Zip.SelfExtractorSaveOptions]
	$SelfExtractorOption = $( New-FPSelfExtractorOption )
	)
	
	#region Main Body
	
	try{
		#validate that the paths passed in are valid for the operation.
		if( -not ( Test-Path $Path )) {
			throw "The path $Path does not exist"
		}
		#create a zip archive and add the items in the path
		if( -not ( Test-Path ( Split-Path $Destination -Parent ))) {
			[System.IO.Directory]::CreateDirectory("$( Split-Path $Destination -Parent )")
		}
		$Zip = New-Object Ionic.Zip.ZipFile
		$Zip.AddItem("$Path","")
		#if the destination SE is already there remove old
		if( Test-Path "$Destination" ){
			Remove-Item "$Destination" -Force
		}
		#create the SE
		$Zip.SaveSelfExtractor("$Destination", $SelfExtractorOption)
	}
	catch{
		Write-Error "$_ was thrown while creating a self extractor"
	}
	
	#endregion
}