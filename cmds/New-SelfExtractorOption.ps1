
<#
	.SYNOPSIS
		returns a self extractor options object
	.DESCRIPTION
		The object returned contains the SFX options that control how the extractor looks, feels, and acts
	.PARAMETER  Copyright
		The year the package was produced.
		Defaults to the current year
	.PARAMETER DefaultExtractDirectory
		The perfered destination of the SFX.
		Defaults to the current working directory
	.PARAMETER Description
		A description of the contents of the SFX
	.PARAMETER ExtractExistingFileAction
		Controls what to do if an existing file already is contained in the destination.
		Defaults to OverwriteSilently
	.PARAMETER FileVersion
		The string version to apply to the Package Major.Minor.Iteration.build example 5.2.1112.54
		will be parsed into System.Version type
	.PARAMETER Flavor
		The type of extractor Console or winforms.
		Defaults to WinFormsApplication
	.PARAMETER IconFile
		The ico file to apply to the package.
		Defaults to the front porch app ico
	.PARAMETER ProductName
		The name of the product contained inside the SFX.
	.PARAMETER Quiet
		Controls wether the SFX emits additional messages after being invoked.
		if this switch is included in the call all messages will be suppressed when the SFX is invoked.
	.EXAMPLE
		PS C:\> $SFXOptions = New-FPSelfExtractorOption -DefaultExtractDirectory 'C:\Extracted' -ProductName 'FPSFX'
	.OUTPUTS
		Ionic.Zip.SelfExtractorSaveOptions
	.NOTES
		The object returned will passed into the New-FPSelfExtractor Function
	.Link
		about_FPPackager_walkthru
#>
function New-FPSelfExtractorOption {
	[CmdletBinding()]
	param(
		[string]
		$Copyright = "$(( Get-Date ).Year )",
		[string]
		$DefaultExtractDirectory = $( Get-Location ),
		[string]
		$Description = "Created by FPPackager",
		[ValidateSet('Throw','OverwriteSilently','DoNotOverwrite')]
		[string]
		$ExtractExistingFileAction = 'OverwriteSilently',
		[string]
		$FileVersion = "1.0.0.1",
		[ValidateSet('ConsoleApplication','WinFormsApplication')]
		[string]
		$Flavor = 'WinFormsApplication',
		[string]
		$IconFile = "$IconDirectory\FPApp.ico",
		[string]
		$ProductName = "Front Porch Package",
		[switch]
		$Quiet
	)
	
	#region Main Body
	
	try {
		#new options object
		$Options = New-Object Ionic.Zip.SelfExtractorSaveOptions
		$Options.Copyright = $Copyright
		$Options.DefaultExtractDirectory = $DefaultExtractDirectory
		$Options.Description = $Description
		#defaults to OverWrite
		$Options.ExtractExistingFile = $ExtractExistingFileAction
		#parse string version to a system.version object
		$Options.FileVersion = try{ [System.Version]::Parse($FileVersion) }catch{ [System.Version]::Parse('1.0.0.1') }
		#defaults to WinFormsApplication
		$Options.Flavor = $Flavor
		#defaults to the FPApp.ico included
		$Options.IconFile = $IconFile
		$Options.ProductName = $ProductName
		$Options.ProductVersion = "$( $FileVersion.ToString() )"
		#controls the install is done without notice
		$Options.Quiet = $Quiet.ToBool()
		#return the options to the caller
		Write-Output $Options
	}
	catch {
		Write-Warning "$_ was thrown. Returning a default object with no options set."
		Write-Output ( New-Object Ionic.Zip.SelfExtractorSaveOptions )
	}
	
	#endregion
	
}
