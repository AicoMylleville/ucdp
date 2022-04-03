$folder = "C:\WindowsExporter"
$textfile = "$folder\textfile_inputs"
$filename = "$folder\WindowsExporter.exe"

Write-Host "    Checking if windows exporter is downloaded."
if (!(Test-Path -Path $filename -PathType leaf)) {
    # Make folder if not exist
    if (!(Test-Path -Path $folder)) {
        mkdir $folder | out-null
        mkdir $textfile | out-null
    }
   
    # download windows_exporter
    $repo = "prometheus-community/windows_exporter"
    $releases = "https://api.github.com/repos/$repo/releases"
    $tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
    $downloadTag = $tag.Split("v")[1]

    $file = "windows_exporter-$downloadTag-amd64.exe"

    $download = "https://github.com/$repo/releases/download/$tag/$file"
    Invoke-WebRequest $download -Out $filename
}

Write-Host "    Running windows exporter on port 9090"
Invoke-Expression -Command "$filename --telemetry.addr :9090"