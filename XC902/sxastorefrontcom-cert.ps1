# habitat.dev.local 証明書の作成
$certParams = @{
    Path = "$PSScriptRoot\xconnect-createcert.json"
    CertificateName = "sxa.storefront.com"
}
Install-SitecoreConfiguration @certParams -Verbose

