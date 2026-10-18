AION2 Polish extras - offline test package

Contains the NcPlatformSdk Polish IOStore trio and the supplemental startup/LOCRES PAK.
Install only copies these four uniquely named payload files into Aion2/Content/Paks/~mods.
It does not include global.utoc/global.ucas, modify existing game files, change the installer,
or enable/load unsigned content. The archive is unsigned; game loading and runtime selection
are untested. Use DryRun first. Restore removes only files whose hashes still match the
ownership state created by Install; modified/missing files cause restore to stop without
removing any other package member.

PowerShell examples:
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Manage-Extras-Polish.ps1 -Mode DryRun -GameRoot "C:\path\to\AION2"
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Manage-Extras-Polish.ps1 -Mode Install -GameRoot "C:\path\to\AION2"
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Manage-Extras-Polish.ps1 -Mode Restore -GameRoot "C:\path\to\AION2"
