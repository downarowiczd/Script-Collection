$AOSMetadataPath = "K:\AOSService\PackagesLocalDirectory"


$RepoPath = ".."
$RepoMetadataPath = $RepoPath + "\isv"
$RepoModelFolders = Get-ChildItem $RepoMetadataPath -Directory
foreach ($ModelFolder in $RepoModelFolders)
{
	cmd /c rmdir "$AOSMetadataPath\$ModelFolder"
}