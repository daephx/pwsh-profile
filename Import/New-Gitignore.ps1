#Requires -Version 3.0
Function New-Gitignore {
	Param(
		[Parameter(Mandatory=$true)]
		[string[]]$List
	)
	$Params = $List -join ","
	Invoke-WebRequest -Uri "http://gitignore.io/api/$Params" |
	Select-Object -expandproperty content |
	Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
	If ($?) { Write-Host Created .gitignore for -> $Params }
	else { Write-Host -fore red "One or more list arguements were unable to be located..." }
}