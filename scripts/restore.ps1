# This script restores the lazy-lock.json file
# to the last from the backup folder

# Get the backup direcotry
$backup_dir = "$env:USERPROFILE\AppData\Local\nvim\lockfiles"

# Check if the directory exists else throw an error
if (-not (Test-Path $backup_dir)) {
    throw "Directory $backup_dir does not exist"
}

# Set the nvim directory
$nvim_dir = "$env:USERPROFILE\AppData\Local\nvim"

# Check if the directory exists else throw an error
if (-not (Test-Path $nvim_dir)) {
    throw "Directory $nvim_dir does not exist"
}


# Get the last modified file in that directory and print it
$last_modified_file = Get-ChildItem -Path $backup_dir -File | Sort-Object LastWriteTime, FullName -Descending | Select-Object -First 1
Write-Host "The last modified file is $($last_modified_file)"

# Check if the file exists and is not a directory
if ( -not (Test-Path -Path $($last_modified_file.FullName) -PathType Leaf)) {
    throw "File $last_modified_file is not a file"
}
else {
    # Prompt the user to confirm the restore
    $confirm = Read-Host "Do you want to restore the file $($last_modified_file.FullName) to the lazy-lock.json file? (y/n)"
    if ($confirm -eq "y") {
        # Set the lazy-lock.json file
        $lazy_lock_file = "$env:USERPROFILE\AppData\Local\nvim\lazy-lock.json"
        # check if the file exists else throw an error
        if (-not (Test-Path $lazy_lock_file)) {
            throw "File $lazy_lock_file does not exist"
        }
        # print it to the user
        Write-Host "Restoring $($last_modified_file.FullName) to $lazy_lock_file"
        # Copy the file to the nvim_dir using the variable for the destination
        Copy-Item -Path $($last_modified_file.FullName) -Destination $nvim_dir
        # Define the path of the copied file
        $copied_file = Join-Path -Path $nvim_dir -ChildPath $($last_modified_file.Name)
        # Delete the lazy-lock.json file
        Remove-Item -Path $lazy_lock_file
        # Rename the copied file to lazy-lock.json
        Rename-Item -Path $copied_file -NewName "lazy-lock.json"
        Write-Host "Done"
    }
    else {
        Write-Host "Aborted"
    }
}