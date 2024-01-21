# This script is used to backup the lazy-lock.json files
# i.e. it takes the into the lockfiles folder and
# renames them based on the date

# Set the nvim directory
$nvim_dir = "$env:USERPROFILE\AppData\Local\nvim"

# Check if the directory exists else throw an error
if (-not (Test-Path $nvim_dir)) {
    throw "Directory $nvim_dir does not exist"
}

# Set the lockfiles directory
$lockfiles_dir = "$nvim_dir\lockfiles"

# Check if the directory exists else throw an error
if (-not (Test-Path $lockfiles_dir)) {
    throw "Directory $lockfiles_dir does not exist"
}

# initial file to copy and then rename
$initial_file = "$nvim_dir\lazy-lock.json"

# check if the file exists else throw an error
if (-not (Test-Path $initial_file)) {
    throw "File $initial_file does not exist"
}

# now check if the initial exists and is not a directory
if ( -not (Test-Path -Path $initial_file -PathType Leaf)) {
    throw "File $initial_file is not a file"
}
else {
    Copy-Item -Path $initial_file -Destination $lockfiles_dir
    $new_name = "$lockfiles_dir\lazy-lock-$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss').json"
    Rename-Item -Path "$lockfiles_dir\lazy-lock.json" -NewName $new_name
    # Print the new name and specify the date format
    Write-Host "Renamed $initial_file to $new_name\n The date format is yyyy-MM-dd-HH-mm-ss"
}