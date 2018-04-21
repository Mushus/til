# Github Pages へ travis でデプロイ

備忘録です。

## 方針

* GHP に自動でデプロイしたい
 - 無料で大御所の travis 使う
* personal pages は master からのみ
 - 公開ファイルと元ネタが分離できない
  - `ghp` っていうリポジトリ切った

## 作業ログ

* travis でデプロイする方針を決める
 - デプロイ方法調べた
  - push するには秘密鍵を travis に配置する必要がある
   - **一番安全な Deploy Key を使う**
   - 公開リポジトリに秘密鍵置くの危ない
    - 公開鍵をリポジトリに含めないといけない秘密鍵を暗号化する必要
     - 暗号化するには [travis.rb](https://github.com/travis-ci/travis.rb) がいる
      - Ruby がいる
       - **入れるのめんどい、Dockerはある**

ということで

```
# ruby コンテナ起動
# コンテナ内で作ったファイルをコピーするために workspace ディレクトリをマウントした
sudo docker run -it -v "$PWD/workspace:/workspace" ruby:latest bash

# travis の cli を入れる
gem install travis

# Deploy key を作る
# 意識高めで強い鍵を作った
ssh-keygen -t ed25519 -P "" -f deploy_key

# コレを xxx.github.io のリポジトリに登録
cat deploy_key.pub

# ログイン必要みたい
travis login --org

# リポジトリ指定必要っぽい
travis encrypt-file -r Mushus/ghp deploy_key

travis encrypt-file deploy_key
```

最後のコマンドでファイルを復元するためのコマンドがもらえるので、デプロイ時に復元して Identity key に設定すれば OK
