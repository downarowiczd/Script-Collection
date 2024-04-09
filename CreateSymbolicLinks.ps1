$AOSMetadataPath = "K:\AOSService\PackagesLocalDirectory"

$RepoPath = ".."
$RepoMetadataPath = $RepoPath + "\isv"
$RepoModelFolders = Get-ChildItem $RepoMetadataPath -Directory
foreach ($ModelFolder in $RepoModelFolders)
{
	$Target = "$RepoMetadataPath\$ModelFolder"
	New-Item -ItemType SymbolicLink -Path "$AOSMetadataPath" -Name "$ModelFolder" -Value "$Target"
}
