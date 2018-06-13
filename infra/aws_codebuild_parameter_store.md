# AWS CodeBuild で SSH ログインする

AWS CodeBuild で SSH ログインするときの覚書

## ユースケース

* codeBuild でリモートに SSH ログインしたい

## やり方

### TL;DR

* AWS System Manager に Identity File を設定する
* 環境変数として読み込む
* install phase でキーを配置

### AWS System Manager に Identity File を設定する

Parameter Store に入れるキーは 4096 文字までなので、なるべく短くて強度のある鍵のほうが良さげ  
また、値は改行を含まない文字列なので base64 にエンコードしとくのが無難
```
ssh-keygen -t ecdsa -b 512 -C "codebuild" -f hoge
base64 hoge > hoge.txt
```

`hoge_pub` はデプロイしたいサーバーの `~/.ssh/authorized_keys` に設定してあげる

### 環境変数として読み込む

CodeBuild の画面から設定  
先程作った `hoge.txt` をキーに設定する  
今回はキーを `SSH_KEY` として設定した  

### install phase で設定を書き込む

こんな感じ。ベースイメージにscpがなかったためインストールしている

```yml
phases:
  install:
    commands: # SSH ログインを設定
      - sudo apt-get update
      - sudo apt-get install -y openssh-client
      - mkdir -p ~/.ssh
      - echo "$SSH_KEY" | base64 -d > ~/.ssh/id_ecdsa
      - chmod 700 ~/.ssh
      - chmod 600 ~/.ssh/id_ecdsa
```

### 完了

こんな感じでつなぐ

```yml
post_build:
  commands:
    - ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_ecdsa -v [ユーザー名]@$TARGET_HOST
    - scp -o StrictHostKeyChecking=no -i ~/.ssh/id_ecdsa -r $PWD [ユーザー名]@$TARGET_HOST:~/
```