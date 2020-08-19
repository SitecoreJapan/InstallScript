param (
  [string]$horizonInstanceName = "horizon.cmsdemo.jp",
  [string]$horizonPhysicalPath = "C:\inetpub\wwwroot\$horizonInstanceName",
  [string]$horizonAppUrl = "https://$horizonInstanceName",
  [string]$sitecoreCmInstanceName = "cm.cmsdemo.jp",
  [string]$sitecoreCmInstanceUrl = "https://$sitecoreCmInstanceName",
  [string]$sitecoreCmInstansePath = "C:\inetpub\wwwroot\$sitecoreCmInstanceName",
  [string]$identityServerPoolName = "account.cmsdemo.jp",
  [string]$identityServerUrl = "https://$identityServerPoolName",
  [string]$identityServerPhysicalPath = "C:\inetpub\wwwroot\$identityServerPoolName",
  [string]$licensePath  = "C:\projects\Horizon",
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
