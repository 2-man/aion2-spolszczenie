param([ValidateSet('Install','Update','Restore')][string]$Mode='Install',[string]$GameRoot='')
$ErrorActionPreference='Stop'
if (Get-Process AION2 -ErrorAction SilentlyContinue) { throw 'Zamknij AION2 przed instalacja lub przywracaniem.' }
if (-not $GameRoot) {
 Add-Type -AssemblyName System.Windows.Forms
 $dialog=New-Object System.Windows.Forms.FolderBrowserDialog
 $dialog.Description='Wybierz folder AION2 zawierajacy katalog Aion2.'
 if ($dialog.ShowDialog() -ne 'OK') { exit 1 }
 $GameRoot=$dialog.SelectedPath
}
$GameRoot=[IO.Path]::GetFullPath($GameRoot)
if (-not (Test-Path -LiteralPath (Join-Path $GameRoot 'Aion2/Binaries/Win64/AION2.exe'))) { throw 'Nieprawidlowy folder gry.' }
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
$manifestPath=if ($Mode -ne 'Restore') { Join-Path $PSScriptRoot 'package.json' } else { Join-Path $support 'package.json' }
$m=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($m.experiment -ne 4 -or $m.originals.Count -ne 4) { throw 'Nieprawidlowy manifest.' }
if (@($m.originals.name | Select-Object -Unique).Count -ne 4) { throw 'Powtorzone pliki.' }
foreach ($o in $m.originals) { if ($o.name -cnotin $names) { throw 'Nieprawidlowa nazwa pliku.' } }
if ($Mode -eq 'Update') {
 $oldManifestPath=Join-Path $support 'package.json'
 $oldText=Get-Content -LiteralPath $oldManifestPath -Raw
 $old=$oldText | ConvertFrom-Json
 if ($old.experiment -ne 4 -or $old.originals.Count -ne 4) { throw 'Nieprawidlowa poprzednia instalacja.' }
 foreach ($o in $m.originals) {
  $previous=@($old.originals | Where-Object { $_.name -ceq $o.name })
  if ($previous.Count -ne 1 -or $previous[0].sha256 -ne $o.sha256) { throw 'Aktualizacja nie pasuje do wersji klienta.' }
  if ((Hash (Join-Path $backup $o.name)) -ne $o.sha256) { throw 'Kopia oryginalu zmieniona.' }
  $active=Join-Path $locale $o.name
  if ($o.name.EndsWith('.pak')) {
   if (-not (Test-Path -LiteralPath $active) -or (Get-Item -LiteralPath $active).Length -ne 0) { throw 'Aktywna paczka jezyka zmieniona.' }
  } elseif (Test-Path -LiteralPath $active) { throw 'Gra odtworzyla oficjalne pliki jezyka. Najpierw przywroc oryginaly.' }
 }
 $payload=Join-Path $PSScriptRoot 'payload/L10NString.dat'
 if ((Hash $payload) -ne $m.datSha256 -or (Hash $dat) -ne $old.datSha256) { throw 'DAT zmieniony lub uszkodzony. Przerwano.' }
 $history=Join-Path $support 'history'
 New-Item -ItemType Directory -Path $history -Force | Out-Null
 $previousDat=Join-Path $history ($old.datSha256+'.dat')
 if ((Test-Path -LiteralPath $previousDat) -and (Hash $previousDat) -ne $old.datSha256) { throw 'Kopia poprzedniego DAT zmieniona.' }
 Copy-Item -LiteralPath $dat -Destination $previousDat -Force
 if ((Hash $previousDat) -ne $old.datSha256) { throw 'Blad kopii poprzedniego DAT.' }
 try {
  Copy-Item -LiteralPath $payload -Destination $dat -Force
  if ((Hash $dat) -ne $m.datSha256) { throw 'Blad zapisu aktualizacji.' }
  Copy-Item -LiteralPath $manifestPath -Destination $oldManifestPath -Force
  Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $support 'Manage-Loose-Polish.ps1') -Force
 } catch {
  Copy-Item -LiteralPath $previousDat -Destination $dat -Force
  [IO.File]::WriteAllText($oldManifestPath,$oldText,[Text.Encoding]::UTF8)
  throw
 }
 Write-Output 'Zaktualizowano polskie teksty. Poprzedni DAT i oryginalne pliki angielskie sa zachowane.'
 exit 0
}
if ($Mode -eq 'Restore') {
 foreach ($o in $m.originals) {
  if ((Hash (Join-Path $backup $o.name)) -ne $o.sha256) { throw 'Kopia zapasowa zmieniona.' }
  $target=Join-Path $locale $o.name
  if (Test-Path -LiteralPath $target) {
   $valid=(Hash $target) -eq $o.sha256
   if ($o.name.EndsWith('.pak') -and (Get-Item -LiteralPath $target).Length -eq 0) { $valid=$true }
   if (-not $valid) { throw 'Plik jezykowy zmieniony po instalacji; przerwano.' }
  }
 }
 if ((Test-Path -LiteralPath $dat) -and (Hash $dat) -ne $m.datSha256) { throw 'DAT zmieniony po instalacji; przerwano.' }
 foreach ($o in $m.originals) {
  Copy-Item -LiteralPath (Join-Path $backup $o.name) -Destination (Join-Path $locale $o.name) -Force
  if ((Hash (Join-Path $locale $o.name)) -ne $o.sha256) { throw 'Blad przywracania.' }
 }
 if (Test-Path -LiteralPath $dat) { Remove-Item -LiteralPath $dat }
 Write-Output 'Przywrocono cztery oryginalne pliki angielskie i usunieto wlasny DAT.'
 exit 0
}
$payload=Join-Path $PSScriptRoot 'payload/L10NString.dat'
if ((Hash $payload) -ne $m.datSha256) { throw 'Uszkodzony polski DAT.' }
if ((Test-Path -LiteralPath $support) -or (Test-Path -LiteralPath $dat)) { throw 'Istnieje poprzednia instalacja lub obcy DAT. Nie nadpisano plikow.' }
foreach ($o in $m.originals) {
 if ((Hash (Join-Path $locale $o.name)) -ne $o.sha256) { throw 'Wersja angielskich plikow rozni sie od paczki. Przerwano.' }
}
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $support 'package.json')
Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $support 'Manage-Loose-Polish.ps1')
$restoreCmd='@echo off'+"`r`n"+'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Loose-Polish.ps1" -Mode Restore -GameRoot "%~dp0.."'+"`r`n"+'pause'+"`r`n"
[IO.File]::WriteAllText((Join-Path $support 'PRZYWROC-ANGIELSKI.cmd'),$restoreCmd,[Text.Encoding]::ASCII)
foreach ($o in $m.originals) {
 Copy-Item -LiteralPath (Join-Path $locale $o.name) -Destination (Join-Path $backup $o.name)
 if ((Hash (Join-Path $backup $o.name)) -ne $o.sha256) { throw 'Blad kopii zapasowej; oryginaly nie zostaly zmienione.' }
}
# Standard loose-resource deployment: retire the archive set, retain an empty named placeholder.
# No executable, DLL, anti-cheat setting, registry or user config is modified.
foreach ($o in $m.originals) { Remove-Item -LiteralPath (Join-Path $locale $o.name) }
[IO.File]::WriteAllBytes((Join-Path $locale 'pakchunk502000-Windows_0_P.pak'),[byte[]]@())
New-Item -ItemType Directory -Path (Split-Path $dat -Parent) -Force | Out-Null
Copy-Item -LiteralPath $payload -Destination $dat
if ((Hash $dat) -ne $m.datSha256) { throw 'Blad kopii DAT. Uruchom przywracanie z AION2-PL-LOOSE.' }
Write-Output 'Polski DAT zainstalowany jako osobny zasob. W grze wybierz English. Test klienta pozostaje do wykonania.'
