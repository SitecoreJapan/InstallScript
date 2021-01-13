param (
  [string]$horizonInstanceName = "horizon.dev.local",
  [string]$horizonPhysicalPath = "C:\inetpub\wwwroot\$horizonInstanceName",
  [string]$horizonAppUrl = "https://$horizonInstanceName",
  [string]$sitecoreCmInstanceName = "XP0.dev.local",
  [string]$sitecoreCmInstanceUrl = "https://$sitecoreCmInstanceName",
  [string]$sitecoreCmInstansePath = "C:\inetpub\wwwroot\$sitecoreCmInstanceName",
  [string]$identityServerPoolName = "XP0.identityserver",
  [string]$identityServerUrl = "https://$identityServerPoolName",
  [string]$identityServerPhysicalPath = "C:\inetpub\wwwroot\$identityServerPoolName",
  [string]$licensePath  = "c:\projects\sif\license.xml",
  [bool]$enableContentHub,
  [ValidateSet("XP", "XM")]
  [string]$topology = "XP"
)
Import-Module "$PSScriptRoot\InstallerModules.psm1" -Force

InstallHorizonHost -horizonInstanceName $horizonInstanceName `
  -sitecoreInstanceUrl $sitecoreCmInstanceUrl `
  -licensePath $licensePath `
  -sitecoreInstansePath $sitecoreCmInstansePath `
  -identityServerPoolName $identityServerPoolName `
  -horizonPhysicalPath $horizonPhysicalPath `
  -identityServerUrl $identityServerUrl `
  -identityServerPhysicalPath $identityServerPhysicalPath `
  -horizonAppUrl $horizonAppUrl `
  -enableContentHub $enableContentHub `
  -topology $topology
