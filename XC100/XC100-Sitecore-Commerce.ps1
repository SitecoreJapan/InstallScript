#Requires -Version 3
param(
    # The root folder with WDP files.
    [string]$XCInstallRoot = "..",
    # The root folder of SIF.Sitecore.Commerce package.
    [string]$XCSIFInstallRoot = $PWD,
    # Specifies whether or not to bypass the installation of the default SXA Storefront. By default, the Sitecore XC installation script also deploys the SXA Storefront.
    [bool]$SkipInstallDefaultStorefront = $false,
    # Specifies whether or not to bypass the installation of the SXA Storefront packages.
    # If set to $true, $TasksToSkip parameter will be populated with the list of tasks to skip in order to bypass SXA Storefront packages installation.
    [bool]$SkipDeployStorefrontPackages = $false,

    # Path to the Master_SingleServer.json file provided in the SIF.Sitecore.Commerce package.
    [string]$Path = "$XCSIFInstallRoot\Configuration\Commerce\Master_SingleServer.json",
    # Path to the Commerce Solr schemas provided as part of the SIF.Sitecore.Commerce package.
    [string]$SolrSchemas = "$XCSIFInstallRoot\SolrSchemas",
    # Path to the SiteUtilityPages folder provided as part of the SIF.Sitecore.Commerce package.
    [string]$SiteUtilitiesSrc = "$XCSIFInstallRoot\SiteUtilityPages",
    # Path to the location where you downloaded the Microsoft.Web.XmlTransform.dll file.
    [string]$MergeToolFullPath = "$XCInstallRoot\MSBuild.Microsoft.VisualStudio.Web.targets*\tools\VSToolsPath\Web\Microsoft.Web.XmlTransform.dll",
    # Path to the Adventure Works Images.OnPrem SCWDP file
    [string]$AdventureWorksImagesWdpFullPath = "$XCInstallRoot\Adventure Works Images.OnPrem.scwdp.zip",
    # Path to the Sitecore Commerce Connect Core SCWDP file.
    [string]$CommerceConnectWdpFullPath = "$XCInstallRoot\Sitecore Commerce Connect Core*.scwdp.zip",
    # Path to the Sitecore Commerce Engine Connect OnPrem SCWDP file.
    [string]$CEConnectWdpFullPath = "$XCInstallRoot\Sitecore Commerce Engine Connect*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Accelerator SCWDP file.
    [string]$SXACommerceWdpFullPath = "$XCInstallRoot\Sitecore Commerce Experience Accelerator*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Accelerator Habitat Catalog SCWDP file.
    [string]$SXAStorefrontCatalogWdpFullPath = "$XCInstallRoot\Sitecore Commerce Experience Accelerator Habitat*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Accelerator Storefront SCWDP file.
    [string]$SXAStorefrontWdpFullPath = "$XCInstallRoot\Sitecore Commerce Experience Accelerator Storefront*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Accelerator Storefront Themes SCWDP file.
    [string]$SXAStorefrontThemeWdpFullPath = "$XCInstallRoot\Sitecore Commerce Experience Accelerator Storefront Themes*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Analytics Core SCWDP file.
    [string]$CommercexAnalyticsWdpFullPath = "$XCInstallRoot\Sitecore Commerce ExperienceAnalytics Core*.scwdp.zip",
    # Path to the Sitecore Commerce Experience Profile Core SCWDP file.
    [string]$CommercexProfilesWdpFullPath = "$XCInstallRoot\Sitecore Commerce ExperienceProfile Core*.scwdp.zip",
    # Path to the Sitecore Commerce Marketing Automation Core SCWDP file.
    [string]$CommerceMAWdpFullPath = "$XCInstallRoot\Sitecore Commerce Marketing Automation Core*.scwdp.zip",
    # Path to the Sitecore Commerce Marketing Automation for AutomationEngine zip file.
    [string]$CommerceMAForAutomationEngineZIPFullPath = "$XCInstallRoot\Sitecore Commerce Marketing Automation for AutomationEngine*.zip",
    # Path to the Sitecore Experience Accelerator zip file.
    [string]$SXAModuleZIPFullPath = "$XCInstallRoot\Sitecore Experience Accelerator*.zip",
    # Path to the Sitecore.PowerShell.Extensions zip file.
    [string]$PowerShellExtensionsModuleZIPFullPath = "$XCInstallRoot\Sitecore.PowerShell.Extensions*.zip",
    # Path to the Sitecore BizFx Server SCWDP file.
    [string]$BizFxPackage = "$XCInstallRoot\Sitecore.BizFx.OnPrem*scwdp.zip",
    # Path to the Commerce Engine Service SCWDP file.
    [string]$CommerceEngineWdpFullPath = "$XCInstallRoot\Sitecore.Commerce.Engine.OnPrem.Solr.*scwdp.zip",
    # Path to the Sitecore.Commerce.Habitat.Images.OnPrem SCWDP file.
    [string]$HabitatImagesWdpFullPath = "$XCInstallRoot\Sitecore.Commerce.Habitat.Images.OnPrem.scwdp.zip",

    # The prefix that will be used on SOLR, Website and Database instances. The default value matches the Sitecore XP default.
    [string]$SiteNamePrefix = "XP0",
    # The name of the Sitecore site instance.
    [string]$SiteName = "sxa.storefront.com",
    # Identity Server site name.
    [string]$IdentityServerSiteName = "$SiteNamePrefix.IdentityServer",
    # The url of the Sitecore Identity server.
    [string]$SitecoreIdentityServerUrl = "https://$IdentityServerSiteName",
    # The Commerce Engine Connect Client Id for the Sitecore Identity Server
    [string]$CommerceEngineConnectClientId = "CommerceEngineConnect",
    # The Commerce Engine Connect Client Secret for the Sitecore Identity Server
    [string]$CommerceEngineConnectClientSecret = "",
    # The host header name for the Sitecore storefront site.
    [string]$SiteHostHeaderName = "sxa.storefront.com",

    # The path of the Sitecore XP site.
    [string]$InstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$SiteName",
    # The path of the Sitecore XConnect site.
    [string]$XConnectInstallDir = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\$SiteNamePrefix.xconnect",
    # The path to the inetpub folder where Commerce is installed.
    [string]$CommerceInstallRoot = "$($Env:SYSTEMDRIVE)\inetpub\wwwroot\",

    # The prefix for Sitecore core and master databases.
    [string]$SqlDbPrefix = $SiteNamePrefix,
    # The location of the database server where Sitecore XP databases are hosted. In case of named SQL instance, use "SQLServerName\\SQLInstanceName"
    [string]$SitecoreDbServer = $($Env:COMPUTERNAME),
    # The name of the Sitecore core database.
    [string]$SitecoreCoreDbName = "$($SqlDbPrefix)_Core",
    # A SQL user with sysadmin privileges.
    [string]$SqlUser = "sa",
    # The password for $SQLAdminUser.
    [string]$SqlPass = "Pleasechang3p@ssword",

    # The name of the Sitecore domain.
    [string]$SitecoreDomain = "sitecore",
    # The name of the Sitecore user account.
    [string]$SitecoreUsername = "admin",
    # The password for the $SitecoreUsername.
    [string]$SitecoreUserPassword = "b",

    # The prefix for the Search index. Using the SiteName value for the prefix is recommended.
    [string]$SearchIndexPrefix = "",
    # The URL of the Solr Server.
    [string]$SolrUrl = "https://localhost:8983/solr",
    # The folder that Solr has been installed to.
    [string]$SolrRoot = "$($Env:SYSTEMDRIVE)\solr-8.4.0",
    # The name of the Solr Service.
    [string]$SolrService = "solr-8.4.0",
    # The prefix for the Storefront index. The default value is the SiteNamePrefix.
    [string]$StorefrontIndexPrefix = $SiteNamePrefix,

    # The host name where Redis is hosted.
    [string]$RedisHost = "localhost",
    # The port number on which Redis is running.
    [string]$RedisPort = "6379",
    # The name of the Redis instance.
    [string]$RedisInstanceName = "Redis",
    # The path to the redis-cli executable.
    [string]$RedisCliPath = "$($Env:SYSTEMDRIVE)\Program Files\Redis\redis-cli.exe",

    # The location of the database server where Commerce databases should be deployed. In case of named SQL instance, use "SQLServerName\\SQLInstanceName"
    [string]$CommerceServicesDbServer = $($Env:COMPUTERNAME),
    # The name of the shared database for the Commerce Services.
    [string]$CommerceServicesDbName = "SitecoreCommerce_SharedEnvironments",
    # The name of the global database for the Commerce Services.
    [string]$CommerceServicesGlobalDbName = "SitecoreCommerce_Global",
    # The port for the Commerce Ops Service.
    [string]$CommerceOpsServicesPort = "5015",
    # The port for the Commerce Shops Service
    [string]$CommerceShopsServicesPort = "5005",
    # The port for the Commerce Authoring Service.
    [string]$CommerceAuthoringServicesPort = "5000",
    # The port for the Commerce Minions Service.
    [string]$CommerceMinionsServicesPort = "5010",
    # The postfix appended to Commerce services folders names and sitenames.
    # The postfix allows you to host more than one Commerce installment on one server.
    [string]$CommerceServicesPostfix = "Sc",
    # The postfix used as the root domain name (two-levels) to append as the hostname for Commerce services.
    # By default, all Commerce services are configured as sub-domains of the domain identified by the postfix.
    # Postfix validation enforces the following rules:
    # 1. The first level (TopDomainName) must be 2-7 characters in length and can contain alphabetical characters (a-z, A-Z) only. Numeric and special characters are not valid.
    # 2. The second level (DomainName) can contain alpha-numeric characters (a-z, A-Z,and 0-9) and can include one hyphen (-) character.
    # Special characters (wildcard (*)), for example, are not valid.
    [string]$CommerceServicesHostPostfix = "sc.com",

    # The name of the Sitecore XC Business Tools server.
    [string]$BizFxSiteName = "SitecoreBizFx",
    # The port of the Sitecore XC Business Tools server.
    [string]$BizFxPort = "4200",

    # The prefix used in the EnvironmentName setting in the config.json file for each Commerce Engine role.
    [string]$EnvironmentsPrefix = "Habitat",
    # The list of Commerce environment names. By default, the script deploys the AdventureWorks and the Habitat environments.
    [array]$Environments = @("AdventureWorksAuthoring", "HabitatAuthoring"),
    # Commerce environments GUIDs used to clean existing Redis cache during deployment. Default parameter values correspond to the default Commerce environment GUIDS.
    [array]$EnvironmentsGuids = @("78a1ea611f3742a7ac899a3f46d60ca5", "40e77b7b4be94186b53b5bfd89a6a83b"),
    # The environments running the minions service. (This is required, for example, for running indexing minions).
    [array]$MinionEnvironments = @("AdventureWorksMinions", "HabitatMinions"),
    # whether to deploy sample data for each environment.
    [bool]$DeploySampleData = $true,

    # The domain of the local account used for the various application pools created as part of the deployment.
    [string]$UserDomain = $Env:COMPUTERNAME,
    # The user name for a local account to be set up for the various application pools that are created as part of the deployment.
    [string]$UserName = "CSFndRuntimeUser",
    # The password for the $UserName.
    [string]$UserPassword = "q5Y8tA3FRMZf3xKN!",

    # The Braintree Merchant Id.
    [string]$BraintreeMerchantId = "",
    # The Braintree Public Key.
    [string]$BraintreePublicKey = "",
    # The Braintree Private Key.
    [string]$BraintreePrivateKey = "",
    # The Braintree Environment.
    [string]$BraintreeEnvironment = "",

    # List of comma-separated task names to skip during Sitecore XC deployment.
    [string]$TasksToSkip = ""
)

Function Resolve-ItemPath {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string] $Path
    )
    process {
        if ([string]::IsNullOrWhiteSpace($Path)) {
            throw "Parameter could not be validated because it contains only whitespace. Please check script parameters."
        }
        $itemPath = Resolve-Path -Path $Path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ([string]::IsNullOrEmpty($itemPath) -or (-not (Test-Path $itemPath))) {
            throw "Path [$Path] could not be resolved. Please check script parameters."
        }

        Write-Host "Found [$itemPath]."
        return $itemPath
    }
}

if (($SkipDeployStorefrontPackages -eq $true) -and ($SkipInstallDefaultStorefront -eq $false)) {
    throw "You cannot install the SXA Storefront without deploying necessary packages. If you want to install the SXA Storefront, set [SkipDeployStorefrontPackages] parameter to [false]."
}

if (($DeploySampleData -eq $false) -and ($SkipInstallDefaultStorefront -eq $false)) {
    throw "You cannot install the SXA Storefront without deploying sample data. If you want to install the SXA Storefront, set [DeploySampleData] parameter to [true]."
}

[string[]] $Skip = @()
if (-not ([string]::IsNullOrWhiteSpace($TasksToSkip))) {
    $TasksToSkip.Split(',') | ForEach-Object { $Skip += $_.Trim() }
}

Push-Location $PSScriptRoot

$modulesPath = ( Join-Path -Path $PWD -ChildPath "Modules" )
if ($env:PSModulePath -notlike "*$modulesPath*") {
    [Environment]::SetEnvironmentVariable("PSModulePath", "$env:PSModulePath;$modulesPath")
}

$deployCommerceParams = @{
    Path                                     = Resolve-ItemPath -Path $Path
    SolrSchemas                              = Resolve-ItemPath -Path $SolrSchemas
    SiteUtilitiesSrc                         = Resolve-ItemPath -Path $SiteUtilitiesSrc
    MergeToolFullPath                        = Resolve-ItemPath -Path $MergeToolFullPath
    AdventureWorksImagesWdpFullPath          = Resolve-ItemPath -Path $AdventureWorksImagesWdpFullPath
    CommerceConnectWdpFullPath               = Resolve-ItemPath -Path $CommerceConnectWdpFullPath
    CEConnectWdpFullPath                     = Resolve-ItemPath -Path $CEConnectWdpFullPath
    SXACommerceWdpFullPath                   = Resolve-ItemPath -Path $SXACommerceWdpFullPath
    SXAStorefrontCatalogWdpFullPath          = Resolve-ItemPath -Path $SXAStorefrontCatalogWdpFullPath
    SXAStorefrontWdpFullPath                 = Resolve-ItemPath -Path $SXAStorefrontWdpFullPath
    SXAStorefrontThemeWdpFullPath            = Resolve-ItemPath -Path $SXAStorefrontThemeWdpFullPath
    CommercexAnalyticsWdpFullPath            = Resolve-ItemPath -Path $CommercexAnalyticsWdpFullPath
    CommercexProfilesWdpFullPath             = Resolve-ItemPath -Path $CommercexProfilesWdpFullPath
    CommerceMAWdpFullPath                    = Resolve-ItemPath -Path $CommerceMAWdpFullPath
    CommerceMAForAutomationEngineZIPFullPath = Resolve-ItemPath -Path $CommerceMAForAutomationEngineZIPFullPath
    SXAModuleZIPFullPath                     = Resolve-ItemPath -Path $SXAModuleZIPFullPath
    PowerShellExtensionsModuleZIPFullPath    = Resolve-ItemPath -Path $PowerShellExtensionsModuleZIPFullPath
    BizFxPackage                             = Resolve-ItemPath -Path $BizFxPackage
    CommerceEngineWdpFullPath                = Resolve-ItemPath -Path $CommerceEngineWdpFullPath
    HabitatImagesWdpFullPath                 = Resolve-ItemPath -Path $HabitatImagesWdpFullPath
    SiteName                                 = $SiteName
    SiteHostHeaderName                       = $SiteHostHeaderName
    InstallDir                               = Resolve-ItemPath -Path $InstallDir
    XConnectInstallDir                       = Resolve-ItemPath -Path $XConnectInstallDir
    CommerceInstallRoot                      = Resolve-ItemPath -Path $CommerceInstallRoot
    CommerceServicesDbServer                 = $CommerceServicesDbServer
    CommerceServicesDbName                   = $CommerceServicesDbName
    CommerceServicesGlobalDbName             = $CommerceServicesGlobalDbName
    SitecoreDbServer                         = $SitecoreDbServer
    SitecoreCoreDbName                       = $SitecoreCoreDbName
    SqlDbPrefix                              = $SqlDbPrefix
    SqlAdminUser                             = $SqlUser
    SqlAdminPassword                         = $SqlPass
    SolrUrl                                  = $SolrUrl
    SolrRoot                                 = Resolve-ItemPath -Path $SolrRoot
    SolrService                              = $SolrService
    SearchIndexPrefix                        = $SearchIndexPrefix
    StorefrontIndexPrefix                    = $StorefrontIndexPrefix
    CommerceServicesPostfix                  = $CommerceServicesPostfix
    CommerceServicesHostPostfix              = $CommerceServicesHostPostfix
    EnvironmentsPrefix                       = $EnvironmentsPrefix
    Environments                             = $Environments
    EnvironmentsGuids                        = $EnvironmentsGuids
    MinionEnvironments                       = $MinionEnvironments
    CommerceOpsServicesPort                  = $CommerceOpsServicesPort
    CommerceShopsServicesPort                = $CommerceShopsServicesPort
    CommerceAuthoringServicesPort            = $CommerceAuthoringServicesPort
    CommerceMinionsServicesPort              = $CommerceMinionsServicesPort
    RedisInstanceName                        = $RedisInstanceName
    RedisCliPath                             = $RedisCliPath
    RedisHost                                = $RedisHost
    RedisPort                                = $RedisPort
    UserDomain                               = $UserDomain
    UserName                                 = $UserName
    UserPassword                             = $UserPassword
    BraintreeMerchantId                      = $BraintreeMerchantId
    BraintreePublicKey                       = $BraintreePublicKey
    BraintreePrivateKey                      = $BraintreePrivateKey
    BraintreeEnvironment                     = $BraintreeEnvironment
    SitecoreDomain                           = $SitecoreDomain
    SitecoreUsername                         = $SitecoreUsername
    SitecoreUserPassword                     = $SitecoreUserPassword
    BizFxSiteName                            = $BizFxSiteName
    BizFxPort                                = $BizFxPort
    SitecoreIdentityServerApplicationName    = $IdentityServerSiteName
    SitecoreIdentityServerUrl                = $SitecoreIdentityServerUrl
    SkipInstallDefaultStorefront             = $SkipInstallDefaultStorefront
    SkipDeployStorefrontPackages             = $SkipDeployStorefrontPackages
    CommerceEngineConnectClientId            = $CommerceEngineConnectClientId
    CommerceEngineConnectClientSecret        = $CommerceEngineConnectClientSecret
    DeploySampleData                         = $DeploySampleData
}

if ($Skip.Count -eq 0) {
    Install-SitecoreConfiguration @deployCommerceParams -Verbose *>&1 | Tee-Object "$XCSIFInstallRoot\XC-Install.log"
}
else {
    Install-SitecoreConfiguration @deployCommerceParams -Skip $Skip -Verbose *>&1 | Tee-Object "$XCSIFInstallRoot\XC-Install.log"
}

# SIG # Begin signature block
# MIIXwQYJKoZIhvcNAQcCoIIXsjCCF64CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUhy349aqDO4jjrB5wZPv+ZL41
# 6RygghL8MIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggUrMIIEE6ADAgECAhAHplztCw0v0TJNgwJhke9VMA0GCSqGSIb3DQEBCwUAMHIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJ
# RCBDb2RlIFNpZ25pbmcgQ0EwHhcNMTcwODIzMDAwMDAwWhcNMjAwOTMwMTIwMDAw
# WjBoMQswCQYDVQQGEwJVUzELMAkGA1UECBMCY2ExEjAQBgNVBAcTCVNhdXNhbGl0
# bzEbMBkGA1UEChMSU2l0ZWNvcmUgVVNBLCBJbmMuMRswGQYDVQQDExJTaXRlY29y
# ZSBVU0EsIEluYy4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7PZ/g
# huhrQ/p/0Cg7BRrYjw7ZMx8HNBamEm0El+sedPWYeAAFrjDSpECxYjvK8/NOS9dk
# tC35XL2TREMOJk746mZqia+g+NQDPEaDjNPG/iT0gWsOeCa9dUcIUtnBQ0hBKsuR
# bau3n7w1uIgr3zf29vc9NhCoz1m2uBNIuLBlkKguXwgPt4rzj66+18JV3xyLQJoS
# 3ZAA8k6FnZltNB+4HB0LKpPmF8PmAm5fhwGz6JFTKe+HCBRtuwOEERSd1EN7TGKi
# xczSX8FJMz84dcOfALxjTj6RUF5TNSQLD2pACgYWl8MM0lEtD/1eif7TKMHqaA+s
# m/yJrlKEtOr836BvAgMBAAGjggHFMIIBwTAfBgNVHSMEGDAWgBRaxLl7Kgqjpepx
# A8Bg+S32ZXUOWDAdBgNVHQ4EFgQULh60SWOBOnU9TSFq0c2sWmMdu7EwDgYDVR0P
# AQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGA1UdHwRwMG4wNaAzoDGG
# L2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3MtZzEuY3Js
# MDWgM6Axhi9odHRwOi8vY3JsNC5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLWNz
# LWcxLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG/WwDATAqMCgGCCsGAQUFBwIBFhxo
# dHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeBDAEEATCBhAYIKwYBBQUH
# AQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTgYI
# KwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFNI
# QTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqG
# SIb3DQEBCwUAA4IBAQBozpJhBdsaz19E9faa/wtrnssUreKxZVkYQ+NViWeyImc5
# qEZcDPy3Qgf731kVPnYuwi5S0U+qyg5p1CNn/WsvnJsdw8aO0lseadu8PECuHj1Z
# 5w4mi5rGNq+QVYSBB2vBh5Ps5rXuifBFF8YnUyBc2KuWBOCq6MTRN1H2sU5LtOUc
# Qkacv8hyom8DHERbd3mIBkV8fmtAmvwFYOCsXdBHOSwQUvfs53GySrnIYiWT0y56
# mVYPwDj7h/PdWO5hIuZm6n5ohInLig1weiVDJ254r+2pfyyRT+02JVVxyHFMCLwC
# ASs4vgbiZzMDltmoTDHz9gULxu/CfBGM0waMDu3cMIIFMDCCBBigAwIBAgIQBAkY
# G1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMG
# A1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQw
# IgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIw
# MDAwWhcNMjgxMDIyMTIwMDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrb
# RPV/5aid2zLXcep2nQUut4/6kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7
# KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCV
# rhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXp
# dOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWO
# D8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IB
# zTCCAckwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1Ud
# HwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgB
# hv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9D
# UFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8G
# A1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IB
# AQA+7A1aJLPzItEVyCx8JSl2qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew
# 4fbRknUPUbRupY5a4l4kgU4QpO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcO
# kRX7uq+1UcKNJK4kxscnKqEpKBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGx
# DI+7qPjFEmifz0DLQESlE/DmZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7Lr
# ZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiF
# LpKR6mhsRDKyZqHnGKSaZFHvMYIELzCCBCsCAQEwgYYwcjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2lnbmlu
# ZyBDQQIQB6Zc7QsNL9EyTYMCYZHvVTAJBgUrDgMCGgUAoHAwEAYKKwYBBAGCNwIB
# DDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFHwhuiBSz5zCUVArLB0+ZBdk
# kxcrMA0GCSqGSIb3DQEBAQUABIIBAC+k4sN12pJTowhwtnxEmKjjqdrpsTDQtziI
# Iw7HhJlRBzqEbxfRc3sTYVvHKuODBZW1Fj9mtB1rYFz5zhgLkQGv+1jlfdtAeUff
# mrZe8LAKk/Gs3n32uDptZcrGcXUHl5oyyQicFMRlmeU0yPp3KhlYz+cdQDewPsKA
# eXuBwDRfTZ6ounInkxlBFcdbTZqwsChUYWC4IaBFb/J4GkAWBlxGPlw3ty3FuT1p
# uwRbNyrOT71/hwFIEdc36Y8M8Q9dEF7sOWKxvEtZ4aCXHtwZhbpT19l8VvDnjtEi
# jtyVS8PoYuISCsnzPr8Vmajn+d/B8XZT+0NnTlLxBeKBhKzZmj+hggILMIICBwYJ
# KoZIhvcNAQkGMYIB+DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMU
# U3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3Rh
# bXBpbmcgU2VydmljZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MjAwNzI5MTQzMjM3WjAjBgkqhkiG9w0BCQQxFgQU1U2FxtyhU0AStBRmZXCxXzYP
# 1uUwDQYJKoZIhvcNAQEBBQAEggEAhtpgsIBkdxtX5EXVK1ZyRm3F+9qh38OCldqF
# Kwf7V9+vjy8lPaJlZ63gM9fpr3OprF0wcwkew8nm4FxlmGCns8tgA1KewkZWpqFu
# pDJKYRyycEySeq8HxTqm/xphUe1YrfOgaACNH+iykhMJDVLsFXyyIcZeHRSJIKjs
# BErKc4xfYZOMr0hjeN988B3jrPkmQHq08p1BmLjQ2DkuORDk16CMXg+yzufifWBv
# 1ssuVldvH25k4aPIg6Q1fcAxUjNL4ST8Zb9e9ximjL7DxIe+VAyhXEfBLYCB53p2
# wUZQ7JEOQJA+c1KEpo8R2cRfVzvkH3kgF9AnMuKnzUM8NnfaTg==
# SIG # End signature block
