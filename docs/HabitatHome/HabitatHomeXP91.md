# Sitecore HabitatHome Platform のインストール

ここで紹介をしている Sitecore HabitatHome Plathome は以下の GitHub のリポジトリで公開されているものを紹介しています。

* [https://github.com/Sitecore/Sitecore.HabitatHome.Platform](https://github.com/Sitecore/Sitecore.HabitatHome.Platform)

## インストール環境の確認

Sitecore Experience Platform 9.1 Initial Release を利用しています。

デモ環境は、Sitecore のインストール環境としては、以下の設定が標準で設定されています。

この製品の <a href="https://github.com/SitecoreJapan/InstallScript/blob/master/docs/91/Sitecore-Experience-Platform-910.md" target="_blank">インストール手順</a> を確認してください。インストール先の情報としては、以下がデフォルトとなっています。この設定を利用しているスクリプトは [ここ](Habitat-91-XP0.ps1) からダウンロードできます。

**プロジェクトの場所**		`c:\projects\Sitecore.HabitatHome.Platform\`
**Habitat サイトドメイン**				`habitathome.dev.local`
**Web Root**						`c:\inetpub\wwwroot`
**Host Suffix**						`dev.local`
**xConnectRoot** 	`habitathome_xconnect.dev.local`

* **インストールディレクトリ**: C:\inetpub\wwwroot\habitathome.dev.local
* **ドメイン名**: https://habitathome.dev.local/
* **xConnect ルート**: C:\inetpub\wwwroot\habitathome_xconnect.dev.local\
* **xConnect ホスト**: habitathome_xconnect.dev.local


```
$prefix = "dev.local"
$XConnectCollectionService = "habitathome_xconnect.dev.local"
$sitecoreSiteName = "habitathome.dev.local"

$xconnectHostName = "habitathome_xconnect.dev.local"
```

Sitecore のクリーンインストールが完了すると、 http://habitathome.dev.local/ でアクセスができるようになり、また /sitecore と入力するとログイン画面が表示されます。

# モジュールのインストール

デモサイトで必要なモジュールをインストールしていきます。モジュールは以下の順番でインストールを進めてください。

* Sitecore PowerShell Extensions-5.0.zip 
* Sitecore Experience Accelerator 1.8 rev. 181112 for 9.1.zip
* Data Exchange Framework 2.1.0 rev. 181113.zip 
* Sitecore Provider for Data Exchange Framework 2.1.0 rev. 181113.zip
* SQL Provider for Data Exchange Framework 2.1.0 rev. 181113.zip
* XConnect Provider for Data Exchange Framework 2.1.0 rev. 181113.zip
* Dynamics Provider for Data Exchange Framework 2.1.0 rev. 181113.zip
* Connect for Microsoft Dynamics 2.1.0 rev. 181113.zip

<img src="images/module_install1.PNG" alt="モジュール一覧" width="450" >

/App_Config/connectionstrings.config に Dynamics につなげるための Connection Strings を追加してください。

```
  <add name="democrm" connectionString="url=https://sitecore1.crm4.dynamics.com/XRMServices/2011/Organization.svc;user id=crmdemo@demo1.onmicrosoft.com;password=password;organization=org;authentication type=2"/>
```

id
password
org

Dynamics 365 のパラメーターを利用してください。

Web.config には以下の設定を追加する必要があります。

```
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Xrm.Sdk" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-8.0.0.0" newVersion="8.0.0.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Crm.Sdk.Proxy" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-8.0.0.0" newVersion="8.0.0.0" />
      </dependentAssembly>
```

# リポジトリのクローン

* Git for Windows

Sitecore の環境が整ったところで、GitHub で提供されているサンプルを適用していきます。ここでは、Visual Studio 2017 の環境実行しています。

1. チームエクスプローラを開き、GitHub のリポジトリの URL を利用してクローンを作成します。作成先は c:\projects\sitecore.habitathome.plathome です。

<img src="images/Github1.PNG" alt="クローンの作成" />

2. インストールに関する設定変更

以下の内容がデフォルトの設定となっています。

**Project location**		`c:\projects\sitecore.habitathome.content\`
**Habitat Site domain**				`habitathome.dev.local`
**Web Root**						`c:\inetpub\wwwroot`
**Host Suffix**						`dev.local`
**xConnectRoot** 	`habitat_xconnect.dev.local`

build.ps1 を実行

```
PS C:\projects\Sitecore.HabitatHome.Content> build.ps1

[13:14:20]
[13:14:20]
[13:14:20]    ) )       /\
[13:14:20]   =====     /  \
[13:14:20]  _|___|____/ __ \____________
[13:14:20] |:::::::::/ ==== \:::::::::::|
[13:14:20] |:::::::::/ ====  \::::::::::|
[13:14:20] |::::::::/__________:::::::::|
[13:14:20] |_________|  ____  |_________|
[13:14:20] | ______  | / || \ | _______ |            _   _       _     _ _        _     _   _
[13:14:20] ||  |   | | ====== ||   |   ||           | | | |     | |   (_) |      | |   | | | |
[13:14:20] ||--+---| | |    | ||---+---||           | |_| | __ _| |__  _| |_ __ _| |_  | |_| | ___  _ __ ___   ___
[13:14:20] ||__|___| | |   o| ||___|___||           |  _  |/ _` | '_ \| | __/ _` | __| |  _  |/ _ \| '_ ` _ \ / _ \
[13:14:20] |======== | |____| |=========|           | | | | (_| | |_) | | || (_| | |_  | | | | (_) | | | | | |  __/
[13:14:20] (^^-^^^^^- |______|-^^^--^^^)            \_| |_/\__,_|_.__/|_|\__\__,_|\__| \_| |_/\___/|_| |_| |_|\___|
[13:14:20] (,, , ,, , |______|,,,, ,, ,)
[13:14:20] ','',,,,'  |______|,,,',',;;
[13:14:20]
[13:14:20]
```

---
[目次に戻る](./readme.md)