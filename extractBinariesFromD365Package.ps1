## this refers to your custom metadata directory

$PLD="C:\MyPackagesLocalDirectory"

## this refers to the binary package you want to extract

$FILES=(Get-ChildItem "C:\Temp\<binary package name>\AOSService\Packages\files")

 

foreach ($file in $FILES) {

$folder=$file.Name.Replace('dynamicsax-', '')

$folder=$folder.Split('.',2)[0]

write-output "mkdir $PLD/$folder"

New-Item -Type directory -Path "$PLD/$folder"

write-output "unzip $file"

Expand-Archive -Path $file -DestinationPath $PLD/$folder

}