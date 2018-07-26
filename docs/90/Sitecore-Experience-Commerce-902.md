# インストール手順
検証済みのバージョンは Sitecore Experience Commerce 9.0 Update 2 になります。

## 環境を整える
今回は、すでにインストール済みの Sitecore Experience Platform に対してインストールをします。
* Sitecore Experience Platform 9.0.2 （[インストール手順](Sitecore-Experience-Platform-902.md) )

以下のモジュールを追加インストールします。
* [.NET Core v2.1.302 SDK (Installer for Windows x64)](https://www.microsoft.com/net/download)
* [.NET Core Windows Server Hosting 2.0.0](https://aka.ms/dotnetcore-2-windowshosting)

またインストールに必要な Braintree のアカウントを用意します
* Braintree の Sandbox アカウント（[Braintree](https://www.braintreepayments.com/sandbox) のサイトから無料で取得できます）

Sitecore Experience Platform 9.0.2 の環境に関しては、インストール開始前に「コントロールパネル」 > 「インデックスマネージャー」を利用して、すべてのインデックスを再構築（ rebuild ）してください。

## ファイルのダウンロードと展開

今回、インストールをするセットは `c:\deploy` のフォルダを作成して展開していきます。まず、Sitecore Experience Commerce 9.0 update 2 のページから、Packages for On Premises 2018.07-2.2.126 ( Sitecore.Commerce.2018.07-2.2.126.zip ) のファイルをダウンロードしてしてください。

ダウンロードしたファイルは、ブロックされている場合は、先にファイルのプロパティを開いて、ブロック解除をする必要があります。解除していただいた後、c:\deploy フォルダに展開します。

```
PS C:\deploy> dir


    ディレクトリ: C:\deploy


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2016/04/05     14:49      243137746 Adventure Works Images.zip
------       2018/06/14     17:51         129663 SIF.Sitecore.Commerce.1.2.14.zip
------       2018/07/05     15:44        1791643 Sitecore Commerce Connect Core 11.2.83.zip
------       2018/07/04     17:07        8444314 Sitecore Commerce Experience Accelerator 1.2.205.zip
------       2018/07/04     17:06          25463 Sitecore Commerce Experience Accelerator Habitat Catalog 1.2.205.zip
------       2018/07/04     17:07        6635282 Sitecore Commerce Experience Accelerator Storefront 1.2.205.zip
------       2018/07/04     17:07        2688408 Sitecore Commerce Experience Accelerator Storefront Themes 1.2.205.zip
------       2018/07/05     15:45         644097 Sitecore Commerce ExperienceAnalytics Core 11.2.83.zip
------       2018/07/05     15:45         644805 Sitecore Commerce ExperienceProfile Core 11.2.83.zip
------       2018/07/05     15:45         106802 Sitecore Commerce Marketing Automation Core 11.2.83.zip
------       2018/07/05     15:45          76992 Sitecore Commerce Marketing Automation for AutomationEngine 11.2.83.zip
------       2018/07/05     15:55        1819617 Sitecore.BizFX.1.2.19.zip
------       2018/06/25     15:16         820683 Sitecore.BizFX.SDK.1.2.19.zip
------       2018/07/05     15:55       23109086 Sitecore.Commerce.Engine.2.2.126.zip
------       2018/07/05     15:52        3365835 Sitecore.Commerce.Engine.Connect.2.2.86.update
------       2018/07/05     15:55       23760988 Sitecore.Commerce.Engine.SDK.2.2.72.zip
------       2017/01/03      7:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
------       2018/05/27     22:20       10886195 Sitecore.IdentityServer.1.2.3.zip
------       2018/05/27     22:20          68541 Sitecore.IdentityServer.SDK.1.2.3.zip
------       2018/07/05     15:53          69124 speak-ng-bcl-0.8.0.tgz
------       2018/07/05     15:53         147896 speak-styling-0.9.0-r00078.tgz


PS C:\deploy>
```

`c:\deploy` の中にある以下のファイルを解凍します。解凍することで、3 つのフォルダが  `c:\deploy` に作成されます。

* SIF.Sitecore.Commerce.1.2.14.zip
* Sitecore.Commerce.Engine.SDK.2.2.72.zip
* Sitecore.BizFX.1.2.19.zip

続いて、 `Microsoft.Web.XmlTransform.dll`を利用するため、以下の Nuget Gallary からファイルをダウンロードします。

* Nuget Gallary - [MSBuild.Microsoft.VisualStudio.Web.targets 14.0.0.3](https://www.nuget.org/packages/MSBuild.Microsoft.VisualStudio.Web.targets/) 

上記のページの Manual download からファイルをダウンロードしたファイル msbuild.microsoft.visualstudio.web.targets.14.0.0.3.nupkg の拡張子 nupkg を zip に変更することで、解凍が可能となります。解凍先は `c:\deploy` で展開してください。

なお、このファイルがダウンロードしてすぐの場合はブロックされていることがあります。プロパティを開いて、ブロックを解除してから展開してください。

上記の作業が完了すると、以下のようなフォルダの構成となります。

```
PS C:\deploy> dir

    ディレクトリ: C:\deploy


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2018/07/26     14:06                assets
d-----       2018/07/26     14:03                msbuild.microsoft.visualstudio.web.targets.14.0.0.3
d-----       2018/07/26     13:54                SIF.Sitecore.Commerce.1.2.14
d-----       2018/07/26     13:31                Sitecore.BizFX.1.2.19
d-----       2018/07/26     13:32                Sitecore.Commerce.Engine.SDK.2.2.72
------       2016/04/05     14:49      243137746 Adventure Works Images.zip
------       2018/06/14     17:51         129663 SIF.Sitecore.Commerce.1.2.14.zip
------       2018/07/05     15:44        1791643 Sitecore Commerce Connect Core 11.2.83.zip
------       2018/07/04     17:07        8444314 Sitecore Commerce Experience Accelerator 1.2.205.zip
------       2018/07/04     17:06          25463 Sitecore Commerce Experience Accelerator Habitat Catalog 1.2.205.zip
------       2018/07/04     17:07        6635282 Sitecore Commerce Experience Accelerator Storefront 1.2.205.zip
------       2018/07/04     17:07        2688408 Sitecore Commerce Experience Accelerator Storefront Themes 1.2.205.zip
------       2018/07/05     15:45         644097 Sitecore Commerce ExperienceAnalytics Core 11.2.83.zip
------       2018/07/05     15:45         644805 Sitecore Commerce ExperienceProfile Core 11.2.83.zip
------       2018/07/05     15:45         106802 Sitecore Commerce Marketing Automation Core 11.2.83.zip
------       2018/07/05     15:45          76992 Sitecore Commerce Marketing Automation for AutomationEngine 11.2.83.zip
------       2018/07/05     15:55        1819617 Sitecore.BizFX.1.2.19.zip
------       2018/06/25     15:16         820683 Sitecore.BizFX.SDK.1.2.19.zip
------       2018/07/05     15:55       23109086 Sitecore.Commerce.Engine.2.2.126.zip
------       2018/07/05     15:52        3365835 Sitecore.Commerce.Engine.Connect.2.2.86.update
------       2018/07/05     15:55       23760988 Sitecore.Commerce.Engine.SDK.2.2.72.zip
------       2017/01/03      7:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
------       2018/05/27     22:20       10886195 Sitecore.IdentityServer.1.2.3.zip
------       2018/05/27     22:20          68541 Sitecore.IdentityServer.SDK.1.2.3.zip
------       2018/07/05     15:53          69124 speak-ng-bcl-0.8.0.tgz
------       2018/07/05     15:53         147896 speak-styling-0.9.0-r00078.tgz
-a----       2018/07/26     13:43            820 storefront.engine.cer


PS C:\deploy>
```

以下のファイルを `c:\deploy\assets` フォルダにダウンロードします。
* [Sitecore Powershell Extensions 4.7.2](https://marketplace.sitecore.net/en/Modules/Sitecore_PowerShell_console.aspx)
* [Sitecore Experience Accelerator 1.7.1](https://dev.sitecore.net/Downloads/Sitecore_Experience_Accelerator/17/Sitecore_Experience_Accelerator_17_Update1.aspx)


最後に、すでに展開している Sitecore.Commerce.Engine.SDK.2.2.72 のフォルダの中にある `Sitecore.Commerce.Engine.DB.dacpac` のファイルも `c:\deploy\assets` のフォルダにコピーをします。


`C:\deploy\assets` のフォルダは以下のような構成になります。

```
PS C:\deploy> cd assets
PS C:\deploy\assets> dir


    ディレクトリ: C:\deploy\assets


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2018/06/22     11:36       22225634 Sitecore Experience Accelerator 1.7.1 rev. 180604 for 9.0.zip
-a----       2018/03/02     10:43        3534996 Sitecore PowerShell Extensions-4.7.2 for Sitecore 8.zip
-a----       2018/06/26     23:06           9251 Sitecore.Commerce.Engine.DB.dacpac


PS C:\deploy\assets>

```

## 証明書の作成

Sitecore Commerce Engine Connect を設定するための証明書を作成します。

```
New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "xp0.engineconnect"
```

上記のコマンドを実行すると表示される Thumbprint を利用して、以下のファイルを作成します。

```
Export-Certificate -Cert cert:\localMachine\my\ {Thumbprint} -FilePath 'C:\deploy\storefront.engine.cer'
```

## MYDeploy-Sitecore-Commerce.ps1 の作成

`C:\deploy\SIF.Sitecore.Commerce.1.2.14` のフォルダに入っているインストール用のスクリプト `Deploy-Sitecore-Commerce.ps1` をコピーして、ファイル名を `MyDeploy-Sitecore-Commerce.ps1` として保存します。

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

実際にインストールに成功しているサンプルの `MyDeploy-Sitecore-Commerce.ps1` を、 XC902 フォルダに参考ファイルとしてアップしておきました。

## xConnect の停止

インストール中、xConnect のインスタンスを止める必要があるため、IIS の管理画面から停止してください。

## インストールスクリプトを実行

あとは PowerShell でスクリプトを実行することで、Solr や Sitecore のプロセスなどがインストールされます。

```
PS C:\deploy\SIF.Sitecore.Commerce.1.2.14> dir *.ps1


    ディレクトリ: C:\deploy\SIF.Sitecore.Commerce.1.2.14


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/06/14     13:51          13303 Deploy-Sitecore-Commerce.ps1
-a----       2018/07/26     13:58          13373 MyDeploy-Sitecore-Commerce.ps1


PS C:\deploy\SIF.Sitecore.Commerce.1.2.14> .\MyDeploy-Sitecore-Commerce.ps1

```

インストール後、xConnect を再開してください。

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
[目次に戻る](../Home.md)