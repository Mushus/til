# URLに日本語を含んでもいいがエンコードしよう

タイトルが結論です。  
PHPでURLに&が入っているとエラーになっていたことの調査した時の話。  

フレームワークは [Phalcon](https://phalconphp.com) を使用しておりました。  
フレームワークには Router が含まれており、index.php のエントリーポイントにリダイレクトされる時に `_url`
というリクエストパラメータにURLが格納されるようになっています。

以下がその .htaccess です。

```.htaccess
AddDefaultCharset UTF-8

<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^(.*)$ index.php?_url=/$1 [QSA,L] # エントリーポイントへのリダイレクト
</IfModule>
```

この時に URL に リクエストパラメータの区切り文字である `&` が含まれると適切に URL が Phalcon の Router に伝わらなくなります。  
[CakePHP](https://cakephp.org) の 3 系では `$_SERVER['REQUEST_URI']` を使用してリクエスト URL を取得しているようです。  
最初はこの辺の違いが問題かと考えていたのですが、「そもそもなんでこんなところに `&` の文字が入ってきているんだ」となったので、
調べてみたら `<img>` 要素の `src` 属性を生成時に適切にURLエンコードされていませんでした。  

実際、 [RFC3986](https://tools.ietf.org/html/rfc3986) では URL に使用可能な文字列が定義されております。  
なので今回入ってきていた URL は実はURLとして不適切だったようです。  

自分もあとから調査中に気づいたのであれなんですが、自分のところに調査依頼が来てる段階で気づかなかったってことは割りと細かいことわかってる人少ないのかな…？  

