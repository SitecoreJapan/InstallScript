# Sitecore XP0 インストール手順
検証済みのバージョンは 9.1 Initial Release になります。また、XP0（スタンドアロンモード）のインストール手順となります。

## 環境を整える
今回は以下の環境で構築をします。

* Windows Server 2016 Standard
* SQL Server 2017 + [SQL Server Management Studio](https://docs.microsoft.com/ja-jp/sql/ssms/download-sql-server-management-studio-ssms)
* IIS 10.0
* .NET Framework 4.7.1

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
* [Win64 OpenSSL v1.1.0g](http://slproweb.com/products/Win32OpenSSL.html)

Solr のインストールに関しては PowerShell を利用してサービス化することができます。

* 作業フォルダ : `c:\projects\sif`
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
PS C:\Users\Sitecore> Get-Module -ListAvailable Sitecore*


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

関連モジュールを一括でインストールするためのスクリプトが用意されています。すでにダウンロードしているファイルを `c:\projects\sif` に展開します。展開したファイルの中に含まれている XP0 Configuration files 9.1.0 rev. 001564.zip もインストールします。

```
PS C:\projects\sif> dir


    ディレクトリ: C:\projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/10/31     12:27           3797 createcert.json
------       2018/10/31     12:27          13042 IdentityServer.json
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


PS C:\projects\sif>
```

このフォルダで、以下のスクリプトを実行すると必要なモジュールをダウンロード、インストールが走ります。

```
Install-SitecoreConfiguration -Path .\Prerequisites.json
```

以下のモジュールに関してはインストールガイドに記載されているため、気になる方はガイドをご覧ください。

## Sitecore Experience Platform 9.1 のインストール

続いて、サンプルの Install スクリプトをダウンロードします。
* [My-XP0-SingleDeveloper.ps1](https://github.com/SitecoreJapan/InstallScript/blob/master/910/)

以下、ファイルを展開する場所に関しては `c:\projects\sif` を想定して記載していきます。  
1. ダウンロードした `InstallScript.ps1` を `c:\projects\sif` にコピーします。
2. ライセンスファイルを `c:\projects\sif` にコピーします
3. 

ディレクトリ `c:\projects\sif` に入っているファイルが以下のようになっているのを確認します。
```
PS C:\Projects\sif> dir


    ディレクトリ: C:\Projects\sif


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2018/06/21     12:30           2393 InstallScript.ps1
-a----       2018/06/21     12:33          77988 license.xml
------       2018/06/04     15:10      251526982 Sitecore 9.0.2 rev. 180604 (OnPrem)_single.scwdp.zip
------       2018/06/04     15:11       35503845 Sitecore 9.0.2 rev. 180604 (OnPrem)_xp0xconnect.scwdp.zip
------       2018/06/01     20:39          15951 sitecore-solr.json
------       2018/06/01     20:39          24853 sitecore-XP0.json
------       2018/06/01     20:39           2572 xconnect-createcert.json
------       2018/06/01     20:39           5084 xconnect-solr.json
------       2018/06/01     20:39          31189 xconnect-xp0.json

PS C:\projects\sif>
```
続いて、InstallScript.ps1 を環境に合わせてセットアップします。
```
$prefix = "xp0"
$PSScriptRoot = "C:\Projects\sif"
$XConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = "$prefix.sc"
$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "C:\solr\solr-6.6.2"
$SolrService = "Solr-6.6.2"
$SqlServer = "."
$SqlAdminUser = "sa"
$SqlAdminPassword="pleasechangepassword"
```
インスタンス名の変更をする必要がない場合は、上記の `$SqlAdminPassword` だけ変更するだけでインストールを実行できます。

```
PS C:\projects\sif> .\InstallScript.ps1
```
これでインストール作業は完了しました。

## インストール後の後処理

インストールが完了したあと、以下のステップを実施してください。

* 日本語リソースのインポート
* インデックスの再構築
* Core / Master データベースのリンクデータの Rebuild
* Marketing Difinision の Deploy 

以上でインストールは完了となります。

[目次に戻る](../Home.md)