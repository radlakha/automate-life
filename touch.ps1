# to add your own functions to powershell, you need to edit your profile
# the profile is a script that is run every time you start powershell
# from powershell prompt edit profile with notepad or your fav editor
# code $profile

# to add touch command add this below code to the end of the file
function Touch-File() {
    $fileName = $args[0]
    # Check of the file exists
    if (-not(Test-Path $fileName)) {
        # It does not exist. Create it
        New-Item -ItemType File -Name $fileName
    }
    else {
        #It exists. Update the timestamp
        (Get-ChildItem $fileName).LastWriteTime = Get-Date
    }
}

### Create an alias for touch

# Check if the alias exists
if (-not(Test-Path -Path Alias:Touch)) {
    New-Alias -Name Touch Touch-File -Force
}