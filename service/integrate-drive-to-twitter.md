# 画像を保存したら勝手に Twitter にアップロードされるようにする

過去に twitter に絵を上げるのを簡単にするために [イラストぽいぽい](http://mushus.dip.jp/illust-poipoi/index.html) という chrome の拡張機能を作ったのですが、実質簡単に「不適切な内容を含む画像として設定」できるだけのクライアントであんまり手間は減りませんでした。

ということでもっと簡単にアップロードする方法を考えたところ、

1. ファイルを保存する
1. 保存された画像を検知する
1. twitter に自動投稿する

しかないかなと思って実現方法を考えました。

そして少し考えたらめちゃくちゃ簡単に実現できてしまうことがわかったため、その方法を紹介しようと思います。

## アーキテクチャ

1. ファイルの保存場所はバックアップも兼ねて [Google Drive](https://www.google.com/intl/ja_ALL/drive/download/) で行います。
1. ファイルの変更をトリガーとして [IFTTT](https://ifttt.com/) のアプレットを実行します。
1. アプレットから [Twitter](https://twitter.com/) へ投稿を行います。

## 設定方法

### Google Drive をインストールする

ローカルの特定のディレクトリにファイルを保存すると自動的にクラウドに保存してくれるようになります。  
[Google Drive](https://www.google.com/intl/ja_ALL/drive/download/) インストールするだけなので省略。  
もしかしたら最初の Google アカウントのログインが失敗するかもしれない(少なくとも自分の環境では失敗した)ので、その場合はブラウザでログイン画面を表示するリンクをクリックすればログインできます。

ちなみにですが、 [Dropbox](https://www.dropbox.com/) や [OneDrive](https://onedrive.live.com/about/ja-jp/) 同様のことはできるかと思います(未確認)。  

### IFTTT を設定する

1. [IFTTT](https://ifttt.com) にサインインします。
1. 右上のアイコンから `New Applet` を選択します。
1. `google drive` で検索して選択します。
1. `New photo in your folder` を選択します。
1. `Drive folder path` に GoogleDrive 中の好きなフォルダ名を入力します。フォルダは事前に作っておいてください。このフォルダにファイルを保存すると自動アップロードされるようになります。
1. `if ○ then +that` の `+that` をクリックします。
1. `Twitter` で検索して選択します。
1. `Post a tweet with image` を選択します。
1. `Tweet text` には自動投稿のツイート内容。 `Image URL` には初期値 `{{PhotoUrl}}` を設定します。
1. `Create action` をクリックします。
1. `Receive notifications when this Applet runs` をオフにして、 `Finish` をクリックして完了です。

### 実際に上げてみる

IFTTT に設定したフォルダにファイルを配置してみてください。設定が正しければしっかり画像が自動に上がると思います。  
数分程度はタイムラグがあるので、もし上がらなかった少し待った後に twitter 見てみてください。  
