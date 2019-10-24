# Sitecore XP0 インストール手順
検証済みのバージョンは 9.0 update 1 ( 9.0.1 ) になります。また、XP0（スタンドアロンモード）のインストール手順となります。

## 環境を整える
今回は以下の環境で構築をします。

* Windows Server 2016 Standard
* SQL Server 2016 Service Pack 1 + [SQL Server Management Studio](https://docs.microsoft.com/ja-jp/sql/ssms/download-sql-server-management-studio-ssms)
* IIS 10.0
* .NET Framework 4.6

SQL Server 2016 SP1 に関しては、管理ツールを利用してインストール後追加設定が必要です。サーバーのプロパティから、「詳細設定」－「コンテインメント」にある項目、「包含データベースの有効化」にを True にしてください。

設定の変更などで活用できる Visual Studio Code もインストールします。

* [Visual Studio Code](https://code.visualstudio.com/download)

以下のモジュールをインストールします。
* [Java 64bit](https://www.java.com/ja/download/manual.jsp)
* [Win64 OpenSSL v1.1.0g](http://slproweb.com/products/Win32OpenSSL.html)
* [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx)

Web Platform Installer をインストールした後、以下のモジュールをインストールします。
* URL Rewrite 2.1
* Web Deploy 3.6 for Hosting

## Solr のインストール
Solr のインストールに関しては PowerShell を利用してサービス化することができます。

* 作業フォルダ : c:\project\solr
* コピーするファイル： [InstallSolr.ps1](https://github.com/SitecoreJapan/InstallScript/tree/master/solr/)

スクリプトを上記のフォルダにコピーをして、実行することで Solr 6.6.2 のサービス設定が完了します。なお、keytool.exe でエラーが出る場合は、Java の Home パスが設定されていない可能性があります。環境設定で Path に追加することでエラーを回避できます。

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
Script     1.1.0      SitecoreFundamentals                {Get-WebFeature, Add-WebFeatureHSTS, Remove-WebFeatureHSTS...
Script     1.1.0      SitecoreInstallFramework            {Export-WebDeployParameters, Get-SitecoreInstallExtension,...
```
これで準備が完了となります。

## Sitecore Experience Platform 9.0.1
パッケージを Web サイトからダウンロードします。
* [Packages for XP Single](https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/90/Sitecore_Experience_Platform_90_Update1.aspx)

続いて、サンプルの Install スクリプトをダウンロードします。
* [InstallScript.ps1](https://github.com/SitecoreJapan/InstallScript/blob/master/901/InstallScript.ps1)

以下、ファイルを展開する場所に関しては `c:\projects\sif` を想定して記載していきます。  
1. ダウンロードした `InstallScript.ps1` を `c:\projects\sif` にコピーします。
2. Sitecore のパッケージを解凍して `c:\projects\sif` に展開します
3. 展開したファイルのうち、`XP0 Configuration files 9.0.1 rev. 171219.zip` のファイルの中身も同じく `c:\projects\sif` に解凍して展開します
4. ライセンスファイルを `c:\projects\sif` にコピーします

ディレクトリ `c:\projects\sif` に入っているファイルが以下のようになっているのを確認します。
```
PS C:\projects\sif> dir

    Directory: C:\projects\sif

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        2/15/2018   7:39 AM           2321 InstallScript.ps1
-a----        11/5/2017  11:05 AM          77988 license.xml
-a----       12/22/2017   1:52 PM      273115417 Sitecore 9.0.1 rev. 171219 (OnPrem)_single.scwdp.zip
-a----       12/22/2017   1:51 PM       30562984 Sitecore 9.0.1 rev. 171219 (OnPrem)_xp0xconnect.scwdp.zip
-a----       12/18/2017   3:27 PM          15951 sitecore-solr.json
-a----       12/18/2017   3:27 PM          24578 sitecore-XP0.json
-a----       12/18/2017   3:27 PM           2572 xconnect-createcert.json
-a----       12/18/2017   3:27 PM           5084 xconnect-solr.json
-a----       12/18/2017   3:27 PM          31189 xconnect-xp0.json


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

---
[目次に戻る](../)