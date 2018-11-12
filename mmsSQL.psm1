$commands = Get-ChildItem -Path "$PSScriptRoot\Commands" -Filter '*.ps1' -Recurse
foreach($command in $commands) { . $command.FullName} 