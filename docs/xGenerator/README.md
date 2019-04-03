# xGenerator の追加

ここでは Sitecore HabitatHome Platform のインストールに対して、アクセスデータを生成するための Addin となる xGenerator に関して紹介をしています。xGenerator をインストールする上で必要な環境は以下の通りです。

* Sitecore Experience Platform 9.1
* [Node.js](https://nodejs.org/ja/) 推奨版をインストールします
* [Build Tools for Visual Studio 2017](https://visualstudio.microsoft.com/ja/downloads/) リンク先のページで、Tools for Visual Studio 2017 の中に含まれています。

## リポジトリのクローンを作成

ここで紹介をしている xGenerator は以下の GitHub のリポジトリで公開されているものを紹介しています。

* [https://github.com/Sitecore/xGenerator](https://github.com/Sitecore/xGenerator)

これを `c:\projects\xGenerator` という形でクローンを作成してください。

## HabitatHome の環境に関して確認

xGenerator も Sitecore.Habitat.Platform のインストールと同様に、Unicorn を利用します。すでに、`web.config` のファイルにおいて Unicorn を Off にしている場合は、On にする必要があります。

```XML
    <add key="unicorn:define" value="ON" />
```

## パラメーターの変更

インストールをするためのパラメーターは、 `cake-config.json` のファイルに定義されています。
以下のように書き換えてください（別のディレクトリ、ドメインの場合は適宜変更）。

**WebsiteRoot**        `C:\inetpub\wwwroot\habitathome.dev.local`
**InstanceUrl**	    `https://habitathome.dev.local/`

## 実行

PowerShell で以下のようにコマンド `build.ps1` を実行してください。

```
PS C:\Users\Administrator> cd \projects\xGenerator
PS C:\projects\xGenerator> dir *.ps1


    ディレクトリ: C:\projects\xGenerator


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2019/04/03     11:20           8258 build.ps1


PS C:\projects\xGenerator> .\build.ps1
Preparing to run build script...
Running build script...
The assembly 'Cake.Http, Version=0.5.0.0, Culture=neutral, PublicKeyToken=null'
is referencing an older version of Cake.Core (0.26.1).
For best compatibility it should target Cake.Core version 0.28.0.
The assembly 'Cake.Json, Version=3.0.1.0, Culture=neutral, PublicKeyToken=null'
is referencing an older version of Cake.Core (0.26.0).
For best compatibility it should target Cake.Core version 0.28.0.
(2717,12): warning CS1701: Assuming assembly reference 'Newtonsoft.Json, Version=9.0.0.0, Culture=neutral, PublicKeyToke
n=30ad4fe6b2a6aeed' used by 'Cake.Json' matches identity 'Newtonsoft.Json, Version=12.0.0.0, Culture=neutral, PublicKeyT
oken=30ad4fe6b2a6aeed' of 'Newtonsoft.Json', you may need to supply runtime policy
(2723,12): warning CS1701: Assuming assembly reference 'Newtonsoft.Json, Version=9.0.0.0, Culture=neutral, PublicKeyToke
n=30ad4fe6b2a6aeed' used by 'Cake.Json' matches identity 'Newtonsoft.Json, Version=12.0.0.0, Culture=neutral, PublicKeyT
oken=30ad4fe6b2a6aeed' of 'Newtonsoft.Json', you may need to supply runtime policy

----------------------------------------
Setup
----------------------------------------

========================================
Clean
========================================

```

## 日本語リソースの追加

インストールが完了したあと、日本語リソースをインポートしてください。リソースに関しては、このリポジトリの中の Demo / xGenerator の中に入っている xml ファイルとなります。


---
[目次に戻る](..\README.md)