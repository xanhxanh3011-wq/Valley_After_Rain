param(
	[switch]$Headless,
	[int]$QuitAfter = 0
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$Godot = "D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe"

if (-not (Test-Path -LiteralPath $Godot)) {
	throw "Godot console binary not found: $Godot"
}

$argsList = @("--path", $ProjectRoot.Path)
if ($Headless) {
	$argsList = @("--headless") + $argsList
}
if ($QuitAfter -gt 0) {
	$argsList += @("--quit-after", "$QuitAfter")
}

& $Godot @argsList
