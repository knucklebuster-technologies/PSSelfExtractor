
<#
	.SYNOPSIS
		returns a self extractor options object
	.DESCRIPTION
		The object returned contains the extractor options that control
		how the extractor looks, feels, and acts
	.PARAMETER  Copyright
		A string to embed in extractor.
		Example - (c) 2018 PSSelfExtactor
	.PARAMETER DefaultExtractDirectory
		The perfered destination of the extractor.
	.PARAMETER Description
		A description of the contents of the extractor
	.PARAMETER ExtractExistingFileAction
		Controls what to do if an existing file already is contained in the destination.
		Defaults to Throw
	.PARAMETER FileVersion
		The version to apply to the extractor Major.Minor.Patch.Build.
		Example 18.4.24.89
	.PARAMETER Flavor
		The type of extractor ConsoleApplication, WinFormsApplication.
		Defaults to WinFormsApplication
	.PARAMETER IconFile
		The ico file to apply to the package.
	.PARAMETER ProductName
		The name of the product contained inside the extractor.
	.PARAMETER Quiet
		Controls wether the extractor emits additional messages after being invoked.
		if this switch is included in the call all messages will be suppressed when the extractor is invoked.
	.EXAMPLE
		PS C:\> $SFXOptions = New-SelfExtractorOption -DefaultExtractDirectory 'C:\Extracted' -ProductName 'MyModule'
#>
function New-SelfExtractorOption {
	[CmdletBinding()]
	param(
		[Parameter(HelpMessage="A copyright string to embed in extractor")]
		[ValidateNotNullOrEmpty()]
		[string]
		$Copyright = "(c) $(( Get-Date ).Year ) PSSelfExtractor",

		[Parameter(HelpMessage="The default extraction path")]
		[ValidateNotNullOrEmpty()]
		[string]
		$DefaultExtractDirectory = 'C:\',

		[Parameter(HelpMessage="A description of the extractor")]
		[string]
		$Description = "Created by Ionic.Zip and PSSelfExtractor",

		[Parameter(HelpMessage="Action to take if the extractors destination already exists Throw, OverwriteSilently, DoNotOverwrite")]
		[ValidateSet('Throw','OverwriteSilently','DoNotOverwrite')]
		[string]
		$ExtractExistingFileAction = 'Throw',

		[Parameter(HelpMessage="Version in form of Major.Minor.Patch.Build i.e. 1.2.1.2")]
		[ValidateNotNull()]
		[System.Version]
		$FileVersion = "$(Get-Date -f MM.dd.yy.mm)",

		[Parameter(HelpMessage="Type of Extractor to create. ConsoleApplication, WinFormsApplication")]
		[ValidateSet('ConsoleApplication','WinFormsApplication')]
		[string]
		$Flavor = 'WinFormsApplication',

		[Parameter(HelpMessage="Path to a .ico file to embed in extractor")]
		[string]
		$IconFile = "",

		[Parameter(HelpMessage="Product name being archived in the extractor")]
		[string]
		$ProductName = "PSSelfExtractor",

		[Parameter(HelpMessage="Controls if the extractor emits additional messages after being invoked")]
		[switch]
		$Quiet
	)

	$Options = New-Object Ionic.Zip.SelfExtractorSaveOptions
	$Options.Copyright = $Copyright
	$Options.DefaultExtractDirectory = $DefaultExtractDirectory
	$Options.Description = $Description
	$Options.ExtractExistingFile = $ExtractExistingFileAction
	$Options.FileVersion = $FileVersion
	$Options.Flavor = $Flavor
	$Options.IconFile = $IconFile
	$Options.ProductName = $ProductName
	$Options.ProductVersion = $FileVersion.ToString()
	$Options.SfxExeWindowTitle = $ProductName
	$Options.Quiet = $Quiet.ToBool()
	Write-Output $Options
}
