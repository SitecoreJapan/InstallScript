# Sitecore XP0 インストール手順
検証済みのバージョンは 9.2 Initial Release になります。また、XP0（スタンドアロンモード）のインストール手順となります。

## 環境を整える
今回は以下の環境で構築をします。

* Windows Server 2019 Standard
* SQL Server 2017 Standard + [SQL Server Management Studio](https://docs.microsoft.com/ja-jp/sql/ssms/download-sql-server-management-studio-ssms)
* IIS 10.0
* [.NET Framework 4.7.1](https://dotnet.microsoft.com/download/dotnet-framework-runtime/net471)
* [.NET Core 2.2 SDK](https://dotnet.microsoft.com/download)
* [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx)

Web Platform Installer をインストールした後、以下のモジュールをインストールします。
* URL Rewrite 2.1
* Web Deploy 3.6 for Hosting

SQL Server 2017 に関しては、Microsoft Machine Learning Server も一緒にインストールをしてください。

インストール完了後、以下の SQL 文を実行します

```
sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO
```

設定の変更などで便利な Visual Studio Code もインストールします。

* [Visual Studio Code](https://code.visualstudio.com/download)

## Solr のインストール

Solr のインストール前に以下のモジュールをインストールします。
* [OpenJDK 64bit](https://openjdk.java.net/)
* [Win64 OpenSSL v1.1.1a](http://slproweb.com/products/Win32OpenSSL.html)

Solr のインストールに関しては PowerShell を利用してサービス化することができます。

* 作業フォルダ : `c:\projects\solr`
* コピーするファイル： [install-solr-7.5.0.ps1](https://github.com/SitecoreJapan/InstallScript/tree/master/solr/)

スクリプトを上記のフォルダにコピーをして、実行することで Solr 7.5.0 のサービス設定が完了します。なお、keytool.exe でエラーが出る場合は、Java の Home パスが設定されていない可能性があります。環境設定で Path に追加することでエラーを回避できます。

## Sitecore Installation Framework のインストール

PowerShell のコンソールを開いて、Nuget のプロバイダーに SitecoreGallery を以下のように追加します

```
Register-PSRepository -Name "SitecoreGallery" -SourceLocation "https://sitecore.myget.org/F/sc-powershell/api/v2/" -InstallationPolicy Trusted
```
上記の手続きが完了していれば、以下のコマンドで Sitecore Installation Framework のインストールが完了します。
```
Install-Module SitecoreInstallFramework
```
以下コマンドでインストールができていることを確認します
```
PS C:\Users\Sitecore> Get-Module -ListAvailable Sitecore*


    Directory: C:\Program Files\WindowsPowerShell\Modules


ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     2.1.0      SitecoreInstallFramework            {Export-WebDeployParameters, Get-SitecoreInstallExtension,...


PS C:\Users\Sitecore>
```
これで準備が完了となります。

## Sitecore Experience Platform 9.2.0 のダウンロード

パッケージを Web サイトからダウンロードします。
* [Packages for XP Single](https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/92/Sitecore_Experience_Platform_92_Initial_Release.aspx)

ファイル名は `Sitecore 9.2.0 rev. 002893 (WDP XP0 packages).zip` となります。

## 関連モジュールのインストール

関連モジュールを一括でインストールするためのスクリプトが用意されています。すでにダウンロードしているファイルを `c:\projects\sif` に展開します。展開したファイルの中に含まれている XP0 Configuration files 9.2.0 rev. 002893.zip も改めて展開をします。

```
PS C:\projects\sif> dir


    Directory: C:\projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------        4/25/2019   3:19 PM           3797 createcert.json
------        4/25/2019   3:19 PM          13835 IdentityServer.json
------        4/25/2019   3:19 PM          18850 Prerequisites.json
------        5/10/2019  12:51 PM      241129383 Sitecore 9.2.0 rev. 002893 (OnPrem)_single.scwdp.zip
------        5/10/2019  12:51 PM       36076244 Sitecore 9.2.0 rev. 002893 (OnPrem)_xp0xconnect.scwdp.zip
------        4/25/2019   3:19 PM          16918 sitecore-solr.json
------        4/25/2019   3:19 PM          31080 sitecore-XP0.json
------        5/10/2019  12:51 PM       16278030 Sitecore.IdentityServer 3.0.0 rev. 00211
                                                 (OnPrem)_identityserver.scwdp.zip
------        4/25/2019   3:19 PM           4088 xconnect-solr.json
------        4/25/2019   3:19 PM          44488 xconnect-xp0.json
------        5/10/2019  12:51 PM          33802 XP0 Configuration files 9.2.0 rev. 002893.zip
------        4/25/2019   3:19 PM          30751 XP0-SingleDeveloper.json
-a----       10/24/2019   2:04 AM          12278 XP0-SingleDeveloper.ps1


PS C:\projects\sif>
```

このフォルダにあるファイルを使って、必要なモジュールをダウンロード、インストールすることができます。

```
PS C:\projects\sif> Install-SitecoreConfiguration -Path .\Prerequisites.json
                                          ************************************
                                               Sitecore Install Framework
                                                     Version - 2.1.0
                                          ************************************


WorkingDirectory       : C:\projects\sif
WhatIf                 : False
Verbose                : SilentlyContinue
Configuration          : C:\projects\sif\Prerequisites.json
Debug                  : SilentlyContinue
AutoRegisterExtensions : False
WarningAction          : Continue
ErrorAction            : Stop
InformationAction      : Continue

```

各モジュールに関してはインストールガイドに記載されているため、気になる方はガイドをご覧ください。

## Sitecore Experience Platform 9.2 のインストール

続いて、サンプルの Install スクリプトをダウンロードします。
* [My-XP0-SingleDeveloper.ps1](https://github.com/SitecoreJapan/InstallScript/blob/master/920/)

以下、ファイルを展開する場所に関しては `c:\projects\sif` を想定して記載していきます。  
1. ダウンロードした `My-XP0-SingleDeveloper.ps1` を `c:\projects\sif` にコピーします。
2. ライセンスファイルを `c:\projects\sif` にコピーします

なお、この `My-XP0-SingleDeveloper.ps1` のファイルはもともと含まれていた `XP0-SingleDeveloper.ps1` を元に作っているため、コピーをせずに自分で設定を決めていただくこともできます。

ディレクトリ `c:\projects\sif` に入っているファイルが以下のようになっているのを確認します。
```
PS C:\projects\sif> dir


    Directory: C:\projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------        4/25/2019   3:19 PM           3797 createcert.json
------        4/25/2019   3:19 PM          13835 IdentityServer.json
-a----       10/22/2019  10:31 AM          65532 license.xml
-a----        8/13/2019   5:46 AM          12280 My-XP0-SingleDeveloper.ps1
------        4/25/2019   3:19 PM          18850 Prerequisites.json
------        5/10/2019  12:51 PM      241129383 Sitecore 9.2.0 rev. 002893 (OnPrem)_single.scwdp.zip
------        5/10/2019  12:51 PM       36076244 Sitecore 9.2.0 rev. 002893 (OnPrem)_xp0xconnect.scwdp.zip
------        4/25/2019   3:19 PM          16918 sitecore-solr.json
------        4/25/2019   3:19 PM          31080 sitecore-XP0.json
------        5/10/2019  12:51 PM       16278030 Sitecore.IdentityServer 3.0.0 rev. 00211
                                                 (OnPrem)_identityserver.scwdp.zip
------        4/25/2019   3:19 PM           4088 xconnect-solr.json
------        4/25/2019   3:19 PM          44488 xconnect-xp0.json
------        5/10/2019  12:51 PM          33802 XP0 Configuration files 9.2.0 rev. 002893.zip
------        4/25/2019   3:19 PM          30751 XP0-SingleDeveloper.json
-a----       10/24/2019   2:20 AM          99228 XP0-SingleDeveloper.log
-a----       10/24/2019   2:04 AM          12278 XP0-SingleDeveloper.ps1


PS C:\projects\sif>
```
続いて、`XP0-SingleDeveloper.ps1` もしくは `My-XP0-SingleDeveloper.ps1` を環境に合わせてセットアップします。なお、Sitecore 9.1 以降からはデフォルトのパスワードの設定が必須となっているため、9.2 でも設定をする必要があります。
```
$Prefix = "sc910"
$SitecoreAdminPassword = "P@ssword"
$SCInstallRoot = "C:\projects\sif"
$XConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = "$prefix.sc"
$XConnectSiteName = "$prefix.xconnect"
$IdentityServerSiteName = "$prefix.identityserver"
$SolrRoot = "C:\solr\solr-7.5.0"
$SolrUrl = "https://localhost:8983/solr"
$SolrService = "Solr-7.5.0"
$SqlServer = "."
$SqlAdminUser = "sa"
$SqlAdminPassword="pleasechangepassword"
```
インスタンス名の変更をする必要がない場合は、上記の `$SqlAdminPassword` だけ変更するだけでインストールを実行できます。

あとはインストールスクリプトを実行してください。

```
PS C:\projects\sif> .\XP0-SingleDeveloper.ps1
```
これでインストール作業は完了しました。

## インストール後の後処理

インストールが完了したあと、以下のステップを実施してください。

* 日本語リソースのインポート
* インデックスの再構築
* Core / Master データベースのリンクデータの Rebuild

以上でインストールは完了となります。

[目次に戻る](../)