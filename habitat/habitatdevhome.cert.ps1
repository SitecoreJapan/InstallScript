# habitat.dev.local 証明書の作成
$certParams = @{
    Path = "$PSScriptRoot\createcert.json"
    CertificateName = "sc910.sc"
}
Install-SitecoreConfiguration @certParams -Verbose

