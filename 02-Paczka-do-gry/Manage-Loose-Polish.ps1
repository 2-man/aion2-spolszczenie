param(
 [ValidateSet('Install','Update','Restore')][string]$Mode='Install',
 [string]$GameRoot=''
)
$ErrorActionPreference='Stop'
if (Get-Process AION2 -ErrorAction SilentlyContinue) { throw 'Zamknij AION2 przed instalacja lub przywracaniem.' }
Write-Output 'AION2 PL installer drop-in 2026-10-18 (auto-path; no client-version comparison).'

# The release files are copied directly into the game's root folder.
if (-not $GameRoot) { $GameRoot=$PSScriptRoot }
$GameRoot=[IO.Path]::GetFullPath($GameRoot)
if (-not (Test-Path -LiteralPath (Join-Path $GameRoot 'Aion2/Binaries/Win64/AION2.exe'))) {
 throw 'Nie znaleziono klienta gry. Skopiuj zawartosc paczki do glownego folderu AION2 obok katalogu Aion2 i uruchom tam INSTALUJ.cmd.'
}
$locale=Join-Path $GameRoot 'Aion2/Content/Paks/L10N/Text/en-US'
$dat=Join-Path $GameRoot 'Aion2/Content/L10N/Text/en-US/L10NString.dat'
$support=Join-Path $GameRoot 'AION2-PL-LOOSE'
$backup=Join-Path $support 'backup'
$names=@('pakchunk502000-Windows_0_P.pak','pakchunk502000-Windows_0_P.sig','pakchunk502000-Windows_0_P.ucas','pakchunk502000-Windows_0_P.utoc')

function Hash([string]$path) {
 $a=[Security.Cryptography.SHA256]::Create();$s=[IO.File]::OpenRead($path)
 try { [BitConverter]::ToString($a.ComputeHash($s)).Replace('-','').ToLowerInvariant() }
 finally { $s.Dispose();$a.Dispose() }
}
function Save-History([string]$label) {
 $history=Join-Path $support 'history'
 New-Item -ItemType Directory -Path $history -Force | Out-Null
 $snapshot=Join-Path $history ($label+'-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'-'+[guid]::NewGuid().ToString('N').Substring(0,8))
 New-Item -ItemType Directory -Path $snapshot | Out-Null
 if (Test-Path -LiteralPath $dat) { Copy-Item -LiteralPath $dat -Destination (Join-Path $snapshot 'L10NString.dat') }
 if (Test-Path -LiteralPath $backup) { Copy-Item -LiteralPath $backup -Destination (Join-Path $snapshot 'backup') -Recurse }
 if (Test-Path -LiteralPath (Join-Path $support 'package.json')) { Copy-Item -LiteralPath (Join-Path $support 'package.json') -Destination (Join-Path $snapshot 'package.json') }
 if (Test-Path -LiteralPath (Join-Path $support 'Manage-Loose-Polish.ps1')) { Copy-Item -LiteralPath (Join-Path $support 'Manage-Loose-Polish.ps1') -Destination (Join-Path $snapshot 'Manage-Loose-Polish.ps1') }
 return $snapshot
}
function Get-InstalledState {
 $allPresent=$true; $allNonempty=$true; $sidecarPresent=$false
 foreach ($name in $names) {
  $path=Join-Path $locale $name
  if (-not (Test-Path -LiteralPath $path)) { $allPresent=$false; continue }
  $item=Get-Item -LiteralPath $path
  if ($item.Length -eq 0) { $allNonempty=$false }
  if ($name -ne 'pakchunk502000-Windows_0_P.pak') { $sidecarPresent=$true }
 }
 if ($allPresent -and $allNonempty) { return 'Full' }
 $pak=Join-Path $locale 'pakchunk502000-Windows_0_P.pak'
 if (-not $sidecarPresent -and (-not (Test-Path -LiteralPath $pak) -or (Get-Item -LiteralPath $pak).Length -eq 0)) { return 'Managed' }
 return 'Partial'
}
function Validate-Backup($manifest) {
 if (-not $manifest -or $null -eq $manifest.originals) { throw 'Brak manifestu kopii zapasowych.' }
 foreach ($o in $manifest.originals) {
  if ($o.name -cnotin $names) { throw 'Nieznana nazwa pliku w manifeście kopii.' }
  $path=Join-Path $backup $o.name
  if (-not (Test-Path -LiteralPath $path) -or (Hash $path) -ne $o.sha256) { throw 'Kopia zapasowa jest niekompletna lub zmieniona. Nie zmieniono plikow gry.' }
 }
}
function New-InstalledManifest($packageManifest) {
 $installed=$packageManifest | ConvertTo-Json -Depth 30 | ConvertFrom-Json
 $installed.originals=@(
  foreach ($name in $names) { if (Test-Path -LiteralPath (Join-Path $backup $name)) {
   $path=Join-Path $backup $name
   [pscustomobject]@{ name=$name; sha256=(Hash $path); bytes=(Get-Item -LiteralPath $path).Length }
  }}
 )
 $installed.datSha256=$packageManifest.datSha256
 return $installed
}

if ($Mode -eq 'Restore') {
 $manifestPath=Join-Path $support 'package.json'
 if (-not (Test-Path -LiteralPath $manifestPath)) { throw 'Brak manifestu instalacji; nie mozna odtworzyc zapisanych plikow.' }
 $installed=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
 Validate-Backup $installed
 New-Item -ItemType Directory -Path $locale -Force | Out-Null
 $restoreNames=@($installed.originals | ForEach-Object { $_.name })
 foreach ($o in $installed.originals) {
  $target=Join-Path $locale $o.name
  # Do not overwrite a non-empty archive installed by a newer game update.
  if (-not (Test-Path -LiteralPath $target) -or (Get-Item -LiteralPath $target).Length -eq 0) {
   Copy-Item -LiteralPath (Join-Path $backup $o.name) -Destination $target -Force
  }
 }
 $pakPath=Join-Path $locale 'pakchunk502000-Windows_0_P.pak'
 if ('pakchunk502000-Windows_0_P.pak' -notin $restoreNames -and (Test-Path -LiteralPath $pakPath) -and (Get-Item -LiteralPath $pakPath).Length -eq 0) { Remove-Item -LiteralPath $pakPath -Force }
 if (Test-Path -LiteralPath $dat) { Remove-Item -LiteralPath $dat -Force }
 Write-Output 'Przywrocono zapisane oryginalne pliki klienta i usunieto polski DAT.'
 exit 0
}
$packagePath=Join-Path $PSScriptRoot 'package.json'
$payload=Join-Path $PSScriptRoot 'payload/L10NString.dat'
if (-not (Test-Path -LiteralPath $packagePath) -or -not (Test-Path -LiteralPath $payload)) { throw 'Brak package.json lub payload/L10NString.dat. Skopiuj cala paczke do folderu gry.' }
$package=Get-Content -LiteralPath $packagePath -Raw | ConvertFrom-Json
if ($package.experiment -ne 4 -or $package.originals.Count -ne 4 -or @($package.originals.name | Select-Object -Unique).Count -ne 4) { throw 'Nieprawidlowy manifest paczki.' }
foreach ($o in $package.originals) { if ($o.name -cnotin $names) { throw 'Nieprawidlowa nazwa pliku w paczce.' } }
if ((Hash $payload) -ne $package.datSha256) { throw 'Polski DAT jest uszkodzony. Przerwano.' }
New-Item -ItemType Directory -Path $locale,(Split-Path $dat -Parent),$backup -Force | Out-Null

$oldManifestPath=Join-Path $support 'package.json'
$oldManifest=$null
if (Test-Path -LiteralPath $oldManifestPath) { $oldManifest=Get-Content -LiteralPath $oldManifestPath -Raw | ConvertFrom-Json }
$state=Get-InstalledState
# Client releases may contain only a subset of the archive quartet. Keep any
# existing backup and refresh it from every non-empty client file found here.
if ($state -eq 'Partial' -or $state -eq 'Full' -or (Test-Path -LiteralPath $dat)) { Save-History 'before-install' | Out-Null }
foreach ($name in $names) {
 $source=Join-Path $locale $name
 if (Test-Path -LiteralPath $source) {
  if ((Get-Item -LiteralPath $source).Length -gt 0 -or ($state -eq 'Partial' -and $name -ne 'pakchunk502000-Windows_0_P.pak')) { Copy-Item -LiteralPath $source -Destination (Join-Path $backup $name) -Force }
 }
}

$installed=New-InstalledManifest $package
$oldManagerPath=Join-Path $support 'Manage-Loose-Polish.ps1'
$oldManagerText=if (Test-Path -LiteralPath $oldManagerPath) { [IO.File]::ReadAllText($oldManagerPath) } else { $null }
$oldManifestText=if (Test-Path -LiteralPath $oldManifestPath) { [IO.File]::ReadAllText($oldManifestPath) } else { $null }
$hadDat=Test-Path -LiteralPath $dat
$datSnapshot=$null
if ($hadDat) {
 $datSnapshot=Join-Path $env:TEMP ('AION2-PL-dat-'+[guid]::NewGuid().ToString('N')+'.bak')
 Copy-Item -LiteralPath $dat -Destination $datSnapshot
}
try {
 foreach ($name in $names) { $target=Join-Path $locale $name; if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target } }
 [IO.File]::WriteAllBytes((Join-Path $locale 'pakchunk502000-Windows_0_P.pak'),[byte[]]@())
 Copy-Item -LiteralPath $payload -Destination $dat -Force
 if ((Hash $dat) -ne $package.datSha256) { throw 'Nie zgadza sie suma zapisanego DAT.' }
 $installed | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $oldManifestPath -Encoding UTF8
 Copy-Item -LiteralPath $PSCommandPath -Destination $oldManagerPath -Force
 $restoreCmd='@echo off' + "`r`n" + 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Loose-Polish.ps1" -Mode Restore -GameRoot "%~dp0.."' + "`r`n" + 'pause' + "`r`n"
 [IO.File]::WriteAllText((Join-Path $support 'PRZYWROC-ANGIELSKI.cmd'),$restoreCmd,[Text.Encoding]::ASCII)
} catch {
 if ($hadDat -and (Test-Path -LiteralPath $datSnapshot)) { Copy-Item -LiteralPath $datSnapshot -Destination $dat -Force }
 elseif (Test-Path -LiteralPath $dat) { Remove-Item -LiteralPath $dat }
 if ($oldManifestText) { [IO.File]::WriteAllText($oldManifestPath,$oldManifestText,[Text.Encoding]::UTF8) }
 if ($oldManagerText) { [IO.File]::WriteAllText($oldManagerPath,$oldManagerText,[Text.Encoding]::UTF8) }
 foreach ($name in $names) {
  $saved=Join-Path $backup $name; $target=Join-Path $locale $name
  if ((Test-Path -LiteralPath $saved) -and (-not (Test-Path -LiteralPath $target) -or (Get-Item -LiteralPath $target).Length -eq 0)) { Copy-Item -LiteralPath $saved -Destination $target -Force }
 }
 throw
} finally {
 if ($datSnapshot -and (Test-Path -LiteralPath $datSnapshot)) { Remove-Item -LiteralPath $datSnapshot -Force }
}
Write-Output 'Polskie teksty zainstalowane. Wybrano jezyk English w ustawieniach gry.'
