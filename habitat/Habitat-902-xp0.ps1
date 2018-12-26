# パラメーターの設定
$prefix = "dev.local"
$PSScriptRoot = "C:\Projects\sif"
$XConnectCollectionService = "habitathome_xconnect.dev.local"
$sitecoreSiteName = "habitathome.dev.local"
$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "C:\solr\solr-6.6.2"
$SolrService = "Solr-6.6.2"
$SqlServer = "."
$SqlAdminUser = "sa"
$SqlAdminPassword="Pleasechang3p@ssword"

# xConnect のためのクライアント証明書のインストール
$certParams = @{
    Path = "$PSScriptRoot\xconnect-createcert.json"
    CertificateName = "$prefix.xconnect_client"
}
Install-SitecoreConfiguration @certParams -Verbose

# xDB のための Solr の設定
$solrParams = @{
    Path = "$PSScriptRoot\xconnect-solr.json"
    SolrUrl = $SolrUrl
    SolrRoot = $SolrRoot
    SolrService = $SolrService
    CorePrefix = $prefix
}
Install-SitecoreConfiguration @solrParams

# xConnect のインスタンスを展開
$xconnectParams = @{
    Path = "$PSScriptRoot\xconnect-xp0.json"
    Package = "$PSScriptRoot\Sitecore 9.0.2 rev. 180604 (OnPrem)_xp0xconnect.scwdp.zip"
    LicenseFile = "$PSScriptRoot\license.xml"
    Sitename = $XConnectCollectionService
    XConnectCert = $certParams.CertificateName
    SqlDbPrefix = $prefix
    SqlServer = $SqlServer
    SqlAdminUser = $SqlAdminUser
    SqlAdminPassword = $SqlAdminPassword
    SolrCorePrefix = $prefix
    SolrURL = $SolrUrl
}
Install-SitecoreConfiguration @xconnectParams

# Sitecore が参照する Solr Core のインストール
$solrParams = @{
    Path = "$PSScriptRoot\sitecore-solr.json"
    SolrUrl = $SolrUrl
    SolrRoot = $SolrRoot
    SolrService = $SolrService
    CorePrefix = $prefix
}
Install-SitecoreConfiguration @solrParams

# Sitecore のインスタンスをインストール
$xconnectHostName = "$prefix.xconnect"
$sitecoreParams = @{
    Path = "$PSScriptRoot\sitecore-XP0.json"
    Package = "$PSScriptRoot\Sitecore 9.0.2 rev. 180604 (OnPrem)_single.scwdp.zip"
    LicenseFile = "$PSScriptRoot\license.xml"
    SqlDbPrefix = $prefix
    SqlServer = $SqlServer
    SqlAdminUser = $SqlAdminUser
    SqlAdminPassword = $SqlAdminPassword
    SolrCorePrefix = $prefix
    SolrUrl = $SolrUrl
    XConnectCert = $certParams.CertificateName
    Sitename = $sitecoreSiteName
    XConnectCollectionService = "https://$xconnectHostName" 
}
Install-SitecoreConfiguration @sitecoreParams
