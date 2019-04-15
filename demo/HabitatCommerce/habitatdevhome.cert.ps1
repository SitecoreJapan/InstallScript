# habitat.dev.local 証明書の作成
$certParams = @{
    Path = "$PSScriptRoot\xconnect-createcert.json"
    CertificateName = "habitathome.dev.local"
}
Install-SitecoreConfiguration @certParams -Verbose

