$ARGC_COMPELTIONS_BASE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ARGC_COMPLETIONS_SCRIPTS = (Get-ChildItem $ARGC_COMPELTIONS_BASE_DIR\completions | ForEach-Object { $_.Name -replace '\.sh$' })

$_argc_completions_scripts = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $argcfile = ($ARGC_COMPELTIONS_BASE_DIR + "\completions\" + $commandAst.CommandElements[0] + ".sh")
    if (!$argcfile) {
        $argcfile = $commandAst.CommandElements[0]
        if (-not(Test-Path -Path $argcfile -PathType Leaf)) {
            return;
        }
    }
    if ($wordToComplete.ToString() -eq "") {
        $tail = " "
    } else {
        $tail = ""
    }
    if ($commandAst.CommandElements.Count -gt 1) {
        $cmds = ($commandAst.CommandElements[1..($commandAst.CommandElements.Count - 1)] -join " ") + $tail
    } else {
        $cmds = $tail
    }
    $comps = (argc --compgen "$argcfile" "$cmds" 2>$null)
    if ($comps -match '^`[^` ]+`$') {
        $comps = (& $ARGC_COMPLETIONS_GIT_BASH "$argcfile" $comps.Substring(1, $comps.Length - 2) 2>$null)
    } elseif ($comps -eq "<FILE>" -or $comps -eq "<PATH>" -or $comps -eq "<FILE>..." -or $comps -eq "<PATH>...") {
        $comps = ("")
    } elseif ($comps -eq "<DIR>" -or $comps -eq "<DIR>...") {
        $comps = ("")
    }
    $comps -split "`n" | 
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object { 
            if ($_.StartsWith("-")) {
                $t = [System.Management.Automation.CompletionResultType]::ParameterName
            } else {
                $t = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
            [System.Management.Automation.CompletionResult]::new($_, $_, $t, '-')
        }
}

Register-ArgumentCompleter -Native -ScriptBlock $_argc_completions_scripts -CommandName $ARGC_COMPLETIONS_SCRIPTS