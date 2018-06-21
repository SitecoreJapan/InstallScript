# インストール手順
検証済みのバージョンは Sitecore Experience Commerce 9.0 Update 1 になります。

## 環境を整える
今回は、すでにインストール済みの Sitecore Experience Platform に対してインストールをします。
* Sitecore Experience Platform 9.0.1 （[インストール手順](https://github.com/SitecoreJapan/InstallScript/wiki/01-Sitecore-Experience-Platform) )

以下のモジュールを追加インストールします。
* [.NET Core 2.1.4 SDK (Installer for Windows x64)](https://www.microsoft.com/net/download/thank-you/dotnet-sdk-2.1.4-windows-x64-installer)
* [ .NET Core Windows Server Hosting 2.0.0](https://aka.ms/dotnetcore-2-windowshosting)

またインストールに必要な Braintree のアカウントを用意します
* Braintree の Sandbox アカウント（[Braintree](https://www.braintreepayments.com/sandbox) のサイトから無料で取得できます）

Sitecore Experience Platform 9.0.1 の環境に関しては、インストール開始前に「コントロールパネル」 > 「インデックスマネージャー」を利用して、すべてのインデックスを再構築（ rebuild ）してください。

## ファイルのダウンロード

今回、インストールをするセットは `c:\deploy` のフォルダを作成して展開していきます。まず、Sitecore Experience Commerce 9.0 update 1 のページから、Packages for On Premises 2018.01-2.0.254 のファイルをダウンロードしてしてください。

ダウンロードしたファイルは、ブロックされているため、先にファイルのプロパティを開いて、ブロック解除をする必要があります。解除していただいた後、c:\deploy フォルダに展開します。

```
PS C:\deploy> dir

    ディレクトリ: C:\deploy

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2016/04/05     14:49      243137746 Adventure Works Images.zip
-a----       2018/03/12      3:42         127946 SIF.Sitecore.Commerce.1.1.4.zip
-a----       2018/03/02     13:27        1792618 Sitecore Commerce Connect Core 11.1.78.zip
-a----       2018/03/14      4:42        3492836 Sitecore Commerce Experience Accelerator 1.1.47.zip
-a----       2018/03/14      4:44           9695 Sitecore Commerce Experience Accelerator Habitat Catalog 1.1.47.zip
-a----       2018/03/14      4:41        5730085 Sitecore Commerce Experience Accelerator Storefront 1.1.47.zip
-a----       2018/03/14      4:43        2393547 Sitecore Commerce Experience Accelerator Storefront Themes 1.1.47.zip
-a----       2018/03/12     16:26        1818138 Sitecore.BizFX.1.1.9.zip
-a----       2018/03/05     15:48         816878 Sitecore.BizFX.SDK.1.1.9.zip
-a----       2018/03/12     16:26       22919650 Sitecore.Commerce.Engine.2.1.55.zip
-a----       2018/03/09      9:13        3227077 Sitecore.Commerce.Engine.Connect.2.1.54.update
-a----       2018/03/12     16:26       23749337 Sitecore.Commerce.Engine.SDK.2.1.10.zip
-a----       2017/01/03      8:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
-a----       2018/03/02     15:33       10884391 Sitecore.IdentityServer.1.1.3.zip
-a----       2018/03/02     15:33          66911 Sitecore.IdentityServer.SDK.1.1.3.zip
-a----       2018/03/12     16:23          69124 speak-ng-bcl-0.8.0.tgz
-a----       2018/03/12     16:23         147896 speak-styling-0.9.0-r00078.tgz
```

以下のファイルを `c:\deploy\assets` フォルダにダウンロードします。
* [Sitecore Powershell Extensions 4.7.2](https://marketplace.sitecore.net/en/Modules/Sitecore_PowerShell_console.aspx)
* [Sitecore Experience Accelerator 1.6](https://dev.sitecore.net/Downloads/Sitecore_Experience_Accelerator/16/Sitecore_Experience_Accelerator_16_Initial_Release.aspx)

また `Microsoft.Web.XmlTransform.dll` も同様に`c:\deploy\assets`にコピーをします。手順としては、まずは以下の URL からモジュールをダウンロードします。

* Nuget Gallary - [MSBuild.Microsoft.VisualStudio.Web.targets 14.0.0.3](https://www.nuget.org/packages/MSBuild.Microsoft.VisualStudio.Web.targets/) 

上記のページの Manual download からファイルをダウンロードしたファイル msbuild.microsoft.visualstudio.web.targets.14.0.0.3.nupkg の拡張子 nupkg を zip に変更することで、解凍が可能となります。解凍したフォルダの `tools\VSToolsPath\Web` の中に、 `Microsoft.Web.XmlTransform.dll` のファイルが見つかります。このファイルも、`c:\deploy\assets` のフォルダにコピーをします。

なお、このファイルのプロパティを開いて、ブロックされている場合は解除する形でファイルを使うことができるようになります。。

## 証明書の作成

Sitecore Commerce Engine Connect を設定するための証明書を作成します。

```
New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname “xp0.engineconnect”
```

上記のコマンドを実行すると表示される Thumbprint を利用して、以下のファイルを作成します。

```
Export-Certificate -Cert cert:\localMachine\my\ {Thumbprint} -FilePath ’C:\deploy\storefront.engine.cer’
```

## ファイルの展開

すでに展開している `c:\deploy` の中にある以下のファイルを解凍します。解凍することで、3 つのフォルダが  `c:\deploy` に作成されます。

* SIF.Sitecore.Commerce.1.1.4.zip
* Sitecore.Commerce.Engine.SDK.2.1.10.zip
* Sitecore.BizFX.1.1.9.zip


完了した段階で、以下のようなフォルダの構成となります。

```
PS C:\deploy> dir

    ディレクトリ: C:\deploy


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2018/03/26     20:44                assets
d-----       2018/03/26     23:04                SIF.Sitecore.Commerce.1.1.4
d-----       2018/03/26     20:55                Sitecore.BizFX.1.1.9
d-----       2018/03/26     20:55                Sitecore.Commerce.Engine.SDK.2.1.10
-a----       2016/04/05     14:49      243137746 Adventure Works Images.zip
-a----       2018/03/02     13:27        1792618 Sitecore Commerce Connect Core 11.1.78.zip
-a----       2018/03/14      4:42        3492836 Sitecore Commerce Experience Accelerator 1.1.47.zip
-a----       2018/03/14      4:44           9695 Sitecore Commerce Experience Accelerator Habitat Catalog 1.1.47.zip
-a----       2018/03/14      4:41        5730085 Sitecore Commerce Experience Accelerator Storefront 1.1.47.zip
-a----       2018/03/14      4:43        2393547 Sitecore Commerce Experience Accelerator Storefront Themes 1.1.47.zip
-a----       2018/03/05     15:48         816878 Sitecore.BizFX.SDK.1.1.9.zip
-a----       2018/03/12     16:26       22919650 Sitecore.Commerce.Engine.2.1.55.zip
-a----       2018/03/09      9:13        3227077 Sitecore.Commerce.Engine.Connect.2.1.54.update
-a----       2017/01/03      8:44      281987890 Sitecore.Commerce.Habitat.Images-1.0.0.zip
-a----       2018/03/02     15:33       10884391 Sitecore.IdentityServer.1.1.3.zip
-a----       2018/03/02     15:33          66911 Sitecore.IdentityServer.SDK.1.1.3.zip
-a----       2018/03/12     16:23          69124 speak-ng-bcl-0.8.0.tgz
-a----       2018/03/12     16:23         147896 speak-styling-0.9.0-r00078.tgz
-a----       2018/03/26     20:47            820 storefront.engine.cer

```

`C:\deploy\assets` のフォルダは以下のような構成になります。

```
PS C:\deploy\assets> dir

    ディレクトリ: C:\deploy\assets


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2016/06/24     19:34          76992 Microsoft.Web.XmlTransform.dll
-a----       2018/01/09     22:53       27264480 Sitecore Experience Accelerator 1.6 rev. 180103 for 9.0.zip
-a----       2018/03/02     10:43        3534996 Sitecore PowerShell Extensions-4.7.2 for Sitecore 8.zip
-a----       2018/03/26     11:25           7873 Sitecore.Commerce.Engine.DB.dacpac

```

最後に、インストール用のスクリプト `my-Deploy-Sitecore-Commerce.ps1` ファイルを `C:\deploy\SIF.Sitecore.Commerce.1.1.4` に保存、また SIF.Sitecore.Commerce.1.1.4\Modules\SitecoreUtilityTasks に `SitecoreUtilityTasks.psm1` をして準備は完了です。

## my-Deploy-Sitecore-Commerce.ps1 の変更

`my-Deploy-Sitecore-Commerce.ps1` に記載されているパラメーターを設定をしてください。

```
    [string]$SiteName = "xp0",	
	[string]$SiteHostHeaderName = "sxa.storefront.com",	
	[string]$SqlDbPrefix = $SiteName,
```

必要に応じて、InstallDir 、XConnectInstallDir などの Sitecore 9.0.1 のインストールしているディレクトリなどに変更をしてください。また、 BraintreeAccount の Sandbox アカウントから取得した以下の項目を入力します。

```
		BraintreeAccount = @{
			MerchantId = ''
			PublicKey = ''
			PrivateKey = ''
```

## xConnect の停止

インストール中、xConnect のインスタンスを止める必要があるため、IIS の管理画面から停止してください。

## インストールスクリプトを実行

あとは PowerShell でスクリプトを実行することで、Solr や Sitecore のプロセスなどがインストールされます。

```
PS C:\deploy\SIF.Sitecore.Commerce.1.1.4> dir

    ディレクトリ: C:\deploy\SIF.Sitecore.Commerce.1.1.4


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
------       2018/03/12      3:42          12854 Deploy-Sitecore-Commerce.ps1
-a----       2018/03/26     20:51          12798 my-Deploy-Sitecore-Commerce.ps1


PS C:\deploy\SIF.Sitecore.Commerce.1.1.4> .\my-Deploy-Sitecore-Commerce.ps1
```

インストール後、xConnect を再開してください。

## Tips
Index の Rebuild で時間がかかってタイムアウトすることがあります。この際は、SIF.Sitecore.Commerce.1.1.4\Configuration\Commerce のフォルダにある json ファイル Master_SingleServer.json を開いて、 Tasks で Rebuild 作業以降にすることで再開できます（以下、サンプル）。

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