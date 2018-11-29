#################################################################
# パラメーターの設定
#################################################################
$scVersion = "9.1.0 rev. 001256"
$prefix = "xp0"
$scriptsRoot = "C:\projects\sif"
$wdpResources = "$scriptsRoot"
$identityServerWdp = "$scriptsRoot\Sitecore.IdentityServer 2.0.0 rev. 00128 (OnPrem)_identityserver.scwdp.zip"
$xConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = "$prefix.sc"
$sitecoreSiteUrl = "http://$sitecoreSiteName"
$identityServerName = "$prefix.IdentityServer"
# $identityServerUrl = "https://$identityServerName"
$clientSecret = "ClientSecret"
$solrUrl = "https://localhost:8983/solr"
$solrRoot = "C:\solr\solr-7.2.1"
$solrService= "Solr-7.2.1"
$sqlServer = "."
$sqlAdminUser = "sa"
$sqlAdminPassword = "Pleasechang3p@ssword"

#################################################################
# xConnect で利用する証明書のインストール
#################################################################
$certParamsForXconnect = @{
    Path = "$wdpResources\xconnect-createcert.json"
    CertificateName = "$prefix.xconnect_client"
}
Install-SitecoreConfiguration @certParamsForXconnect -Verbose

#################################################################
# xDB で利用する SOLR コアのインストール
#################################################################
$solrParams = @{
    Path = "$wdpResources\xconnect-solr.json"
    SolrUrl = $solrUrl
    SolrRoot = $solrRoot
    SolrService = $solrService
    CorePrefix = $prefix
}
Install-SitecoreConfiguration @solrParams

#################################################################
#  XConnect のインスタンスを展開
#################################################################
$xconnectParams = @{
    Path = "$wdpResources\xconnect-xp0.json"
    Package = "$scriptsRoot\Sitecore $scVersion (OnPrem)_xp0xconnect.scwdp.zip"
    LicenseFile = "$scriptsRoot\license.xml"
    Sitename = $XConnectCollectionService
    XConnectCert = $certParamsForXconnect.CertificateName
    SqlDbPrefix = $prefix
    SqlServer = $sqlServer
    SqlAdminUser = $sqlAdminUser
    SqlAdminPassword = $sqlAdminPassword
    SolrCorePrefix = $prefix
    SolrUrl = $solrUrl
    MachineLearningServerUrl = "XXX"
}
Install-SitecoreConfiguration @xconnectParams

#################################################################
# Sitecore インスタンスのインストール
#################################################################

$sitecoreParams = @{
    Path = "$wdpResources\sitecore-XP0.json"
    Package = "$scriptsRoot\Sitecore $scVersion (OnPrem)_single.scwdp.zip"
    LicenseFile = "$scriptsRoot\license.xml"
    SqlDbPrefix = $prefix
    SqlServer = $sqlServer
    SqlAdminUser = $sqlAdminUser
    SqlAdminPassword = $sqlAdminPassword
    SolrCorePrefix = $prefix
    SolrUrl = $solrUrl
    XConnectCert = $certParamsForXconnect.CertificateName
    Sitename = $sitecoreSiteName
    XConnectReportingService = "https://$XConnectCollectionService"
    XConnectCollectionService = "https://$XConnectCollectionService"
    MarketingAutomationOperationsService = "https://$XConnectCollectionService"
    MarketingAutomationReportingService = "https://$XConnectCollectionService"
    SitecoreIdentityAuthority = "https://$identityServerName"
    SitecoreIdentitySecret = $clientSecret
}
Install-SitecoreConfiguration @sitecoreParams

#################################################################
# Install client certificate for Identity Server
#################################################################
$certParamsForIdentityServer = @{
    Path = "$wdpResources\xconnect-createcert.json"
    CertificateName = $identityServerName
}
Install-SitecoreConfiguration @certParamsForIdentityServer -Verbose

#################################################################
# Deploy Identity Server
#################################################################
$allowedCorsOrigins = "<AllowedCorsOrigin1>$sitecoreSiteUrl</AllowedCorsOrigin1>"
$clientConfiguration = @"
<Clients>
    <DefaultClient>
        <AllowedCorsOrigins>
            $allowedCorsOrigins
        </AllowedCorsOrigins>
    </DefaultClient>
    <PasswordClient>
        <AllowedCorsOrigins>
            $allowedCorsOrigins
        </AllowedCorsOrigins>
        <ClientSecrets>
            <ClientSecret1>$clientSecret</ClientSecret1>
        </ClientSecrets>
    </PasswordClient>
</Clients>
"@

$identityParams = @{
    Path = "$wdpResources\IdentityServer.json"
    Package = $identityServerWdp
    SqlDbPrefix = $prefix
    SqlServer = $sqlServer
    SqlCoreUser = $sqlAdminUser
    SqlCorePassword = $sqlAdminPassword
    SitecoreIdentityCert = $certParamsForIdentityServer.CertificateName
    Sitename = $identityServerName
    PasswordRecoveryUrl ="$sitecoreSiteUrl"
    ClientsConfiguration = $clientConfiguration
    LicenseFile = "$scriptsRoot\license.xml"
    }

Install-SitecoreConfiguration @identityParams -Verbose