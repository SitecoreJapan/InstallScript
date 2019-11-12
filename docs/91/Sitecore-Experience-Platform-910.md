# Sitecore XP0 インストール手順
検証済みのバージョンは 9.1 Initial Release になります。また、XP0（スタンドアロンモード）のインストール手順となります。

## 環境を整える
今回は以下の環境で構築をします。

* Windows Server 2016 Standard
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
* [Java 64bit](https://www.java.com/ja/download/manual.jsp)
* [Win64 OpenSSL v1.1.1a](http://slproweb.com/products/Win32OpenSSL.html)

Solr のインストールに関しては PowerShell を利用してサービス化することができます。

* 作業フォルダ : `c:\projects\solr`
* コピーするファイル： [install-solr-7.2.1-java-1.8.0-191.ps1](https://github.com/SitecoreJapan/InstallScript/tree/master/solr/)

スクリプトを上記のフォルダにコピーをして、実行することで Solr 7.2.1 のサービス設定が完了します。なお、keytool.exe でエラーが出る場合は、Java の Home パスが設定されていない可能性があります。環境設定で Path に追加することでエラーを回避できます。

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
PS C:\Users\Administrator> Get-Module -ListAvailable Sitecore*


    ディレクトリ: C:\Program Files\WindowsPowerShell\Modules


ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     2.0.0      SitecoreInstallFramework            {Export-WebDeployParameters, Get-SitecoreInstallExtension,...


PS C:\Users\Administrator>
```
これで準備が完了となります。

## Sitecore Experience Platform 9.1 のダウンロード

パッケージを Web サイトからダウンロードします。
* [Packages for XP Single](https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/91/Sitecore_Experience_Platform_91_Initial_Release.aspx)

ファイル名は `Sitecore 9.1.0 rev. 001564 (WDP XP0 packages).zip` となります。

## 関連モジュールのインストール

関連モジュールを一括でインストールするためのスクリプトが用意されています。すでにダウンロードしているファイルを `c:\projects\sif` に展開します。展開したファイルの中に含まれている XP0 Configuration files 9.1.0 rev. 001564.zip も改めて展開をします。

```
PS C:\Projects\sif> dir


    ディレクトリ: C:\Projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/10/31     12:27           3797 createcert.json
------       2018/10/31     12:27          13042 IdentityServer.json
-a----       2018/08/08     12:24          65522 license.xml
------       2018/10/31     12:27          18158 Prerequisites.json
------       2018/11/01     12:07      266793116 Sitecore 9.1.0 rev. 001564 (OnPrem)_single.scwdp.zip
------       2018/11/01     12:07       29433870 Sitecore 9.1.0 rev. 001564 (OnPrem)_xp0xconnect.scwdp.zip
------       2018/10/31     12:27          16918 sitecore-solr.json
------       2018/10/31     12:27          31080 sitecore-XP0.json
-a----       2018/11/05     16:37       12590364 Sitecore.IdentityServer 2.0.0 rev. 00157 (OnPrem)_identityserver.scwdp
                                                 .zip
------       2018/10/31     12:27           4088 xconnect-solr.json
------       2018/10/31     12:27          44488 xconnect-xp0.json
-a----       2018/11/02     20:22          23212 XP0 Configuration files 9.1.0 rev. 001564.zip
------       2018/10/31     12:27          30084 XP0-SingleDeveloper.json
-a----       2018/11/02     11:59           3596 XP0-SingleDeveloper.ps1


PS C:\Projects\sif>
```

このフォルダにあるファイルを使って、必要なモジュールをダウンロード、インストールすることができます。

```
PS C:\projects\sif> Install-SitecoreConfiguration -Path .\Prerequisites.json
警告: スクリプト 'Invoke-RemoveSqlDatabaseTask.ps1' を実行できません。このスクリプトの #requires
ステートメントで指定された次のモジュールがありません: SqlServer。
                                          ************************************
                                               Sitecore Install Framework
                                                     Version - 2.0.0
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

## Sitecore Experience Platform 9.1 のインストール

続いて、サンプルの Install スクリプトをダウンロードします。
* [My-XP0-SingleDeveloper.ps1](https://github.com/SitecoreJapan/InstallScript/blob/master/910/)

以下、ファイルを展開する場所に関しては `c:\projects\sif` を想定して記載していきます。  
1. ダウンロードした `My-XP0-SingleDeveloper.ps1` を `c:\projects\sif` にコピーします。
2. ライセンスファイルを `c:\projects\sif` にコピーします

なお、この `My-XP0-SingleDeveloper.ps1` のファイルはもともと含まれていた `XP0-SingleDeveloper.ps1` を元に作っているため、コピーをせずに自分で設定を決めていただくこともできます。

ディレクトリ `c:\projects\sif` に入っているファイルが以下のようになっているのを確認します。
```
PS C:\projects\sif> dir


    ディレクトリ: C:\projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/10/31     12:27           3797 createcert.json
------       2018/10/31     12:27          13042 IdentityServer.json
-a----       2018/08/08     12:24          65522 license.xml
-a----       2018/12/07     10:37           3606 My-XP0-SingleDeveloper.ps1
------       2018/10/31     12:27          18158 Prerequisites.json
------       2018/11/01     12:07      266793116 Sitecore 9.1.0 rev. 001564 (OnPrem)_single.scwdp.zip
------       2018/11/01     12:07       29433870 Sitecore 9.1.0 rev. 001564 (OnPrem)_xp0xconnect.scwdp.zip
------       2018/10/31     12:27          16918 sitecore-solr.json
------       2018/10/31     12:27          31080 sitecore-XP0.json
-a----       2018/11/05     16:37       12590364 Sitecore.IdentityServer 2.0.0 rev. 00157 (OnPrem)_identityserver.scwdp
                                                 .zip
------       2018/10/31     12:27           4088 xconnect-solr.json
------       2018/10/31     12:27          44488 xconnect-xp0.json
-a----       2018/11/02     20:22          23212 XP0 Configuration files 9.1.0 rev. 001564.zip
------       2018/10/31     12:27          30084 XP0-SingleDeveloper.json
-a----       2018/11/02     11:59           3596 XP0-SingleDeveloper.ps1

```
続いて、`XP0-SingleDeveloper.ps1` もしくは `My-XP0-SingleDeveloper.ps1` を環境に合わせてセットアップします。なお、Sitecore 9.1 からはデフォルトのパスワードの設定が必須となっています。
```
$Prefix = "sc910"
$SitecoreAdminPassword = "P@ssword"
$SCInstallRoot = "C:\projects\sif"
$XConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = "$prefix.sc"
$XConnectSiteName = "$prefix.xconnect"
$IdentityServerSiteName = "$prefix.identityserver"
$SolrRoot = "C:\solr\solr-7.2.1"
$SolrUrl = "https://localhost:8983/solr"
$SolrService = "Solr-7.2.1"
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

---
[目次に戻る](../)