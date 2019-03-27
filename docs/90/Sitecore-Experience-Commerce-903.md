# インストール手順
検証済みのバージョンは Sitecore Experience Commerce 9.0 Update 3 になります。

## 環境を整える
今回は、すでにインストール済みの Sitecore Experience Platform に対してインストールをします。
* Sitecore Experience Platform 9.0.2 （[インストール手順](Sitecore-Experience-Platform-902.md) )

以下のモジュールを追加インストールします。
* [.NET Core SDK v2.2.100 (Installer for Windows x64)](https://www.microsoft.com/net/download)
* [.NET Core Windows Server Hosting 2.0.0](https://aka.ms/dotnetcore-2-windowshosting)
* [ASP.NET MVC 4](https://www.microsoft.com/ja-jp/download/details.aspx?id=30683)

またインストールに必要な Braintree のアカウントを用意します
* Braintree の Sandbox アカウント（[Braintree](https://www.braintreepayments.com/sandbox) のサイトから無料で取得できます）

Sitecore Experience Platform 9.0.2 の環境に関しては、インストール開始前に「コントロールパネル」 > 「インデックスマネージャー」を利用して、すべてのインデックスを再構築（ rebuild ）してください。

## ファイルのダウンロードと展開

今回、インストールをするセットは `c:\projects\sc903` のフォルダを作成して展開していきます。まず、Sitecore Experience Commerce 9.0 update 3 のページから、`Packages for On Premise 2018.12-2.4.63` ( Sitecore.Commerce.2018.12-2.4.63.zip ) のファイルをダウンロードしてしてください。

ダウンロードしたファイルは、ブロックされている場合は、先にファイルのプロパティを開いて、ブロック解除をする必要があります。解除していただいた後、`c:\projects\sc903` フォルダに展開します。

```
PS C:\projects\sc903> dir


    ディレクトリ: C:\projects\sc903


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2016/04/05     14:49      243137746 Adventure Works Images.zip
------       2018/12/03      9:13         129721 SIF.Sitecore.Commerce.1.4.7.zip
------       2018/11/21     15:34        1977890 Sitecore Commerce Connect Core 11.4.15.zip
------       2018/12/03      9:13        9059150 Sitecore Commerce Experience Accelerator 1.4.150.zip
------       2018/12/03      9:13          24309 Sitecore Commerce Experience Accelerator Habitat Catalog 1.4.150.zip
------       2018/12/03      9:13        6580533 Sitecore Commerce Experience Accelerator Storefront 1.4.150.zip
------       2018/12/03      9:13        2429688 Sitecore Commerce Experience Accelerator Storefront Themes 1.4.150.zip
------       2018/11/21     15:38         680743 Sitecore Commerce ExperienceAnalytics Core 11.4.15.zip
------       2018/11/21     15:37         646424 Sitecore Commerce ExperienceProfile Core 11.4.15.zip
------       2018/11/21     15:39         106703 Sitecore Commerce Marketing Automation Core 11.4.15.zip
------       2018/11/21     15:40          76968 Sitecore Commerce Marketing Automation for AutomationEngine 11.4.15.zip
------       2018/12/03      9:20        1819688 Sitecore.BizFX.1.4.1.zip
------       2018/09/26     19:04         820742 Sitecore.BizFX.SDK.1.4.1.zip
------       2018/12/03      9:20       23318372 Sitecore.Commerce.Engine.2.4.63.zip
------       2018/12/01     17:19        3407922 Sitecore.Commerce.Engine.Connect.2.4.32.update
------       2018/12/03      9:21       26960846 Sitecore.Commerce.Engine.SDK.2.4.43.zip
------       2017/01/03      7:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
------       2018/11/20     17:13       10981982 Sitecore.IdentityServer.1.4.2.zip
------       2018/11/20     17:11          68624 Sitecore.IdentityServer.SDK.1.4.2.zip
------       2018/12/03      9:13          34778 SolrSchemas.Sitecore.Commerce.1.4.7.zip
------       2018/12/03      9:15          69124 speak-ng-bcl-0.8.0.tgz
------       2018/12/03      9:15         147896 speak-styling-0.9.0-r00078.tgz


PS C:\projects\sc903>
```

`c:\projects\sc903` の中にある以下のファイルを解凍します。解凍することで、3 つのフォルダが  `c:\projects\sc903` に作成されます。

* SIF.Sitecore.Commerce.1.4.7.zip
* Sitecore.Commerce.Engine.SDK.2.4.43.zip
* Sitecore.BizFX.1.4.1.zip

上記の 3 つのファイルは不要となりますので、削除してください。

続いて、 `Microsoft.Web.XmlTransform.dll`を利用するため、以下の Nuget Gallary からファイルをダウンロードします。

* Nuget Gallary - [MSBuild.Microsoft.VisualStudio.Web.targets 14.0.0.3](https://www.nuget.org/packages/MSBuild.Microsoft.VisualStudio.Web.targets/) 

上記のページの Manual download からファイルをダウンロードしたファイル msbuild.microsoft.visualstudio.web.targets.14.0.0.3.nupkg の拡張子 nupkg を zip に変更することで、解凍が可能となります。解凍先は `c:\projects\sc903` で展開してください。

なお、このファイルがダウンロードしてすぐの場合はブロックされていることがあります。プロパティを開いて、ブロックを解除してから展開してください。

上記の作業が完了すると、以下のようなフォルダの構成となります。

```
PS C:\projects\sc903> dir


    ディレクトリ: C:\projects\sc903


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2018/12/11      0:19                msbuild.microsoft.visualstudio.web.targets.14.0.0.3
d-----       2018/12/11      0:17                SIF.Sitecore.Commerce.1.4.7
d-----       2018/12/11      0:16                Sitecore.BizFX.1.4.1
d-----       2018/12/11      0:16                Sitecore.Commerce.Engine.SDK.2.4.43
------       2016/04/05     14:49      243137746 Adventure Works Images.zip
------       2018/11/21     15:34        1977890 Sitecore Commerce Connect Core 11.4.15.zip
------       2018/12/03      9:13        9059150 Sitecore Commerce Experience Accelerator 1.4.150.zip
------       2018/12/03      9:13          24309 Sitecore Commerce Experience Accelerator Habitat Catalog 1.4.150.zip
------       2018/12/03      9:13        6580533 Sitecore Commerce Experience Accelerator Storefront 1.4.150.zip
------       2018/12/03      9:13        2429688 Sitecore Commerce Experience Accelerator Storefront Themes 1.4.150.zip
------       2018/11/21     15:38         680743 Sitecore Commerce ExperienceAnalytics Core 11.4.15.zip
------       2018/11/21     15:37         646424 Sitecore Commerce ExperienceProfile Core 11.4.15.zip
------       2018/11/21     15:39         106703 Sitecore Commerce Marketing Automation Core 11.4.15.zip
------       2018/11/21     15:40          76968 Sitecore Commerce Marketing Automation for AutomationEngine 11.4.15.zip
------       2018/09/26     19:04         820742 Sitecore.BizFX.SDK.1.4.1.zip
------       2018/12/03      9:20       23318372 Sitecore.Commerce.Engine.2.4.63.zip
------       2018/12/01     17:19        3407922 Sitecore.Commerce.Engine.Connect.2.4.32.update
------       2017/01/03      7:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
------       2018/11/20     17:13       10981982 Sitecore.IdentityServer.1.4.2.zip
------       2018/11/20     17:11          68624 Sitecore.IdentityServer.SDK.1.4.2.zip
------       2018/12/03      9:13          34778 SolrSchemas.Sitecore.Commerce.1.4.7.zip
------       2018/12/03      9:15          69124 speak-ng-bcl-0.8.0.tgz
------       2018/12/03      9:15         147896 speak-styling-0.9.0-r00078.tgz


PS C:\projects\sc903>
```

以下のファイルを `c:\projects\sc902\assets` フォルダにダウンロードします。
* [Sitecore Powershell Extensions 4.7.2](https://marketplace.sitecore.net/en/Modules/Sitecore_PowerShell_console.aspx)
* [Sitecore Experience Accelerator 1.8 for 9.0](https://dev.sitecore.net/Downloads/Sitecore_Experience_Accelerator/18/Sitecore_Experience_Accelerator_180.aspx)


最後に、すでに展開している Sitecore.Commerce.Engine.SDK.2.2.72 のフォルダの中にある `Sitecore.Commerce.Engine.DB.dacpac` のファイルも `c:\projects\sc902\assets` のフォルダにコピーをします。


`C:\projects\sc902\assets` のフォルダは以下のような構成になります。

```
PS C:\projects\sc903> cd assets
PS C:\projects\sc903\assets> dir


    ディレクトリ: C:\projects\sc903\assets


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2018/12/10     15:43       32163097 Sitecore Experience Accelerator 1.8 rev. 181112 for 9.0.zip
-a----       2018/03/02     10:43        3534996 Sitecore PowerShell Extensions-4.7.2 for Sitecore 8.zip
-a----       2018/12/01     15:39          14009 Sitecore.Commerce.Engine.DB.dacpac


PS C:\projects\sc903\assets>

```

## 証明書の作成

Sitecore Commerce Engine Connect を設定するための証明書を作成します。

```
New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "sxa.storefront.com"
```

上記のコマンドを実行すると表示される Thumbprint を利用して、以下のファイルを作成します。

```
Export-Certificate -Cert cert:\localMachine\my\{Thumbprint} -FilePath 'C:\projects\sc903\assets\storefront.engine.cer'
```

## MYDeploy-Sitecore-Commerce.ps1 の作成

`C:\projects\sc903\SIF.Sitecore.Commerce.1.4.7` のフォルダに入っているインストール用のスクリプト `Deploy-Sitecore-Commerce.ps1` をコピーして、ファイル名を `MyDeploy-Sitecore-Commerce.ps1` として保存します。

`MyDeploy-Sitecore-Commerce.ps1` のファイルを開いて、以下のパラメーターの確認をしてください。

```
  [string]$SiteName = "xp0",	
	[string]$SiteHostHeaderName = "sxa.storefront.com",	
	[string]$SqlDbPrefix = $SiteName,

  SolrRoot = "c:\\solr\\solr-6.6.2"
```

必要に応じて、InstallDir 、XConnectInstallDir などの Sitecore 9.0.2 のインストールしているディレクトリなどに変更をしてください。また、 BraintreeAccount の Sandbox アカウントから取得した以下の項目を入力します。

```
		BraintreeAccount = @{
			MerchantId = ''
			PublicKey = ''
			PrivateKey = ''
```

実際にインストールに成功しているサンプルの `MyDeploy-Sitecore-Commerce.ps1` を、 XC903 フォルダに参考ファイルとしてアップしておきました。

## xConnect は稼働させる

Sitecore Commerce 9.0.1 まではここで xConnect を停止させる手順でしたが、Sitecore Commerce 9.0.2 以降はインストール中は xConnect のインスタンスを稼働させる必要があるため、動いていればそのままにしてください。

## インストールスクリプトを実行

あとは PowerShell でスクリプトを実行することで、Solr や Sitecore のプロセスなどがインストールされます。

```
PS C:\projects\sc903\SIF.Sitecore.Commerce.1.4.7> dir *.ps1


    ディレクトリ: C:\projects\sc903\SIF.Sitecore.Commerce.1.4.7


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/12/03      6:17          13303 Deploy-Sitecore-Commerce.ps1
-a----       2018/12/11     17:58          13272 MyDeploy-Sitecore-Commerce.ps1


PS C:\projects\sc903\SIF.Sitecore.Commerce.1.4.7>

```

## インストール後の処理

Sitecore Experience Commerce 9.0.3 のインストールが完了したあと、以下の手順で日本語リソースをインポートしてください。

- Sitecore の日本語リソースの適用（ https://dev.sitecore.net からダウンロードした Sitecore 9.0.2 rev. 180604 (ja-JP).zip をアップロード）
- Sitecore Experience Acceleartor 1.8 の日本語リソースの適用（ temp/SXAtranslations/ja-jp.xml にファイルがあります）
- Github で展開している Sitecore Commerce Experience 9.0.3 リソースファイル、Commerce-core-ja-jp.xml を Core データベースに、Commerce-master-ja-jp.xml を Master データベースに適用します

Sitecore Experience Commerce のビジネスツールの日本語リソースは従来の管理と異なり、Master データベースで変更してリソースデータベースをクリアする、という手順になっています。このため SQL Server Management Tool を起動してサーバーに接続、SitecoreCommerce9_SharedEnvironments のデータベースにある ContentEntities のテーブルのデータをクリアしてください。

```
DELETE FROM [SitecoreCommerce9_SharedEnvironments].[dbo].[ContentEntities]
```

データをクリアしたあと、IIS を再起動すると、次回にビジネスツールを起動する際に Masnter データベースのデータを利用して、リソースが更新される形です。

## Tips
Index の Rebuild で時間がかかってタイムアウトすることがあります。この際は、SIF.Sitecore.Commerce.1.2.14\Configuration\Commerce のフォルダにある json ファイル Master_SingleServer.json を開いて、 Tasks で Rebuild 作業以降にすることで再開できます（以下、サンプル）。

```
  "Tasks": {
    // Tasks are separate units of work in a configuration.
    // Each task is an action that will be completed when Install-SitecoreConfiguration is called.
    // By default, tasks are applied in the order they are declared.
    // Tasks may reference Parameters, Variables, and config functions.
    "Reindex": {
      "Type": "InstallSitecoreConfiguration",
      "Params": {
        "Path": ".\\Configuration\\SitecoreUtilities\\RebuildIndexes.json",
        "BaseUrl": "[variable('UtilitiesBaseUrl')]"
      }
    },
    "RemoveSiteUtilityFolder": {
      "Type": "ManageCommerceService",
      "Params": {
        "Name": "Name",
        "PhysicalPath": "[variable('SiteUtilitiesDir')]",
        "Action": "Remove-Item"
      }
    }
  }
  ```
[目次に戻る](../readme.md)