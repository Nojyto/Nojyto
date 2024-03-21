# Profile C:\Users\nojus\Documents\WindowsPowerShell
# Terminal %LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState

Clear-Host

# Theme
oh-my-posh --init --shell pwsh --config ~/AppData/Local/Programs/oh-my-posh/themes/powerlevel10k_rainbow.omp.json | Invoke-Expression

# Autocomplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Shortcuts
Set-Alias winfetch pwshfetch-test-1
New-Alias -Name cfj -Value ConvertFrom-Json
New-Alias -Name ctj -Value ConvertTo-Json

# Functions
Function uptime {
	Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

Function find-file($name) {
	Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
		$place_path = $_.directory
		Write-Output "${place_path}\${_}"
	}
}

Function unzip ($file) {
	$dirname = (Get-Item $file).Basename
	Write-Output ("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}

Function get-foldersize {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )    
    (Get-ChildItem $FolderPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB | ForEach-Object { "{0:N2} MB" -f $_ }
}