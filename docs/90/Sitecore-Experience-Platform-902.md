# Sitecore XP0 インストール手順
検証済みのバージョンは 9.0 update 2 ( 9.0.2 ) になります。また、XP0（スタンドアロンモード）のインストール手順となります。

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
* [Win64 OpenSSL v1.1.1a](http://slproweb.com/products/Win32OpenSSL.html)
* [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx)

Web Platform Installer をインストールした後、以下のモジュールをインストールします。
* URL Rewrite 2.1
* Web Deploy 3.6 for Hosting

## Solr のインストール
Solr のインストールに関しては PowerShell を利用してサービス化することができます。

* 作業フォルダ : c:\project\solr
* コピーするファイル： [install-solr-1.8.0_191.ps1](https://github.com/SitecoreJapan/InstallScript/tree/master/solr/)

スクリプトを上記のフォルダにコピーをして、実行することで Solr 6.6.2 のサービス設定が完了します。なお、keytool.exe でエラーが出る場合は、Java の Home パスが設定されていない可能性があります。環境設定で Path に追加することでエラーを回避できます。

## Sitecore Installation Framework のインストール

今回は Siecore Install Framework 1.2 をマニュアルインストールします。以下のページから、Sitecore Installation Framework および Sitecore Fundamentals をダウンロードします。

* [Sitecore Installation Framework 1.2](https://dev.sitecore.net/Downloads/Sitecore_Installation_Framework/1x/Sitecore_Installation_Framework_12.aspx)

ダウンロードした Zip ファイルのプロパティを開き、それぞれブロックを解除します。

上記のモジュールは、それぞれ以下のフォルダに展開をしてください。

`C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals`
`C:\Program Files\WindowsPowerShell\Modules\SitecoreInstallFramework`

展開後のディレクトリを確認すると以下のようになります。

```
PS C:\Users\Administrator> cd "C:\Program Files\WindowsPowerShell\Modules\SitecoreInstallFramework"
PS C:\Program Files\WindowsPowerShell\Modules\SitecoreInstallFramework> dir


    ディレクトリ: C:\Program Files\WindowsPowerShell\Modules\SitecoreInstallFramework


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2018/12/10     22:56                docs
d-----       2018/12/10     22:56                en-US
d-----       2018/12/10     22:56                lib
d-----       2018/12/10     22:56                Private
d-----       2018/12/10     22:56                Public
------       2018/02/12      9:34          16171 SitecoreInstallFramework.psd1
------       2018/02/12      9:33           9202 SitecoreInstallFramework.psm1
------       2018/02/12      9:33          11712 SitecoreInstallFramework.types.ps1xml


PS C:\Program Files\WindowsPowerShell\Modules\SitecoreInstallFramework> cd "C:\Program Files\WindowsPowerShell\Modules\S
itecoreFundamentals"
PS C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals> dir


    ディレクトリ: C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2018/12/10     22:56                Content
d-----       2018/12/10     22:56                docs
d-----       2018/12/10     22:56                en-US
d-----       2018/12/10     22:56                Private
d-----       2018/12/10     22:56                Public
------       2017/12/08     15:45          14376 SitecoreFundamentals.psd1
------       2017/12/08     15:45          10150 SitecoreFundamentals.psm1


PS C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals>

```
 `Get-Module -ListAvailable Sitecore*` を実行して、コマンドを認識できていれば、インストールは完了です。

```
PS C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals>  Get-Module -ListAvailable Sitecore*


    ディレクトリ: C:\Program Files\WindowsPowerShell\Modules


ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     1.1.0      SitecoreFundamentals                {Get-WebFeature, Add-WebFeatureHSTS, Remove-WebFeatureHSTS...
Script     1.2.0      SitecoreInstallFramework            {Export-WebDeployParameters, Get-SitecoreInstallExtension,...


PS C:\Program Files\WindowsPowerShell\Modules\SitecoreFundamentals>
```

## Sitecore Experience Platform 9.0.2
パッケージを Web サイトからダウンロードします。
* [Packages for XP Single](https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/90/Sitecore_Experience_Platform_90_Update2.aspx)

続いて、サンプルの Install スクリプトをダウンロードします。
* [InstallScript.ps1](https://github.com/SitecoreJapan/InstallScript/blob/master/902/InstallScript.ps1)

以下、ファイルを展開する場所に関しては `c:\projects\sif` を想定して記載していきます。  
1. ダウンロードした `InstallScript.ps1` を `c:\projects\sif` にコピーします。
2. Sitecore のパッケージを解凍して `c:\projects\sif` に展開します
3. 展開したファイルのうち、`XP0 Configuration files 9.0.2 rev. 180604.zip` のファイルの中身も同じく `c:\projects\sif` に解凍して展開します
4. ライセンスファイルを `c:\projects\sif` にコピーします

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

---
[目次に戻る](../)