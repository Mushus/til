# cassandra をローカルで動かすまで(WIP)

環境: MacOS 10.13.6

## cassandra とは

* キーバリューストア
* NoSQL(SQLライクなCQLというものはある)
* MySQLより断然早いらしい
* 単一障害性が低い

使ってみた限りだと情報が少ないのとツール類が辛い  
あと同期が取れなかったときに死ぬっぽいのでメンテコストはMySQLより高いんじゃないかなと心配

## cassandra の cli ツールをインストール

`cassandra-cli` というのを見たがどうやら `cqlsh` に統合された模様。なのでそちらを使う。

`cqlsh` を使用するには python2 系が必要とのこと

すでに `pip` `pyenv` は導入済みだった。ただし python2 は入っていない

```bash
# pythonのバージョンのリストを出した
$ pyenv install -l

# 2.7 系の最新のバージョンを選んだ
$ pyenv install 2.7.15

# ローカル全体の python を 2.7 系に変更した
$ pyenv global 2.7.15

# cqlsh をインストールした
$ pip install cqlsh

# インストールできた
$ cqlsh --version
```

NOTE: python3でインストールしてしまったときは `pip unsintall cqlsh` でアンインストールする必要がある

## casandra のインストール

dockerでインストールすることにした


```docker-compose.yml
version: '3.6'
services:
  cassandra:
    container_name: cassandra
    image: cassandra:latest
    ports:
      - 9042:9042
```

```bash
# そのままだとエラーが出た
$ cqlsh
Connection error: ('Unable to connect to any servers', {'127.0.0.1': ProtocolError("cql_version '3.3.1' is not supported by remote (w/ native protocol). Supported versions: [u'3.4.4']",)})

# 今回の環境だとこれで動いた
$ cqlsh --cqlversion 3.4.4
```

### 参考

https://stackoverflow.com/questions/33002404/cassandra-cqlsh-unable-to-connect-to-any-servers

## リモートの cassandra に接続

今回 22 と 80 と 443 のポートしか空いてないらしかったため、ポートフォワードしてから接続してダンプを行った。

``` bash
# リモートの cassandra のポート 9042 にローカルのポート 9142 から接続できるようにする
$ ssh -L 9142:localhost:9042 xxx@xxx.xxx.xxx.xxx

# リモートではパスワード使ってた
$ cqlsh -u xxx -p xxx localhost 9142
```

## cassandra のスキーマ定義を取得

```cql
// keyspace を表示(MySQLでいう `SHOW DATABASES` みたいなの)
DESCRIBE KEYSPACES;
```

一応スキーマのダンプはこれでできるようだが、データがついてこない。データをダンプする場合はテーブル毎にやる必要があるっぽい。今回は調べたけどいい方法が見つからなかった。
```bash
# スキーマのダンプ
$ cqlsh -e "describe full schema" > schema.cql
```

サードパーティ製のツールに cassandradumpというものを見つけたのでそれを使う。
ただしインストール方法が書いてなかったので、暫定対応でインストールした。

```bash
# 取得
git clone git@github.com:gianlucaborello/cassandradump.git

# 実行
python ./cassandradump/cassandradump.py help
```

これでデータも含まれている `dump.cql` ファイルができた
```bash
$ python ./cassandradump/cassandradump.py --protocol-version 3 --username xxx --password xxx --host localhost --port 9142 --keyspace xxx --export-file dump.cql
```

## スキーマのリストア

export を import にするだけ

```bash
$ python ./cassandradump/cassandradump.py --protocol-version 3 --host localhost --port 9042 --keyspace xxx --import-file dump.cql

# 確認してみる
cqlsh --cqlversion 3.4.4
> describe keyspaces;
> use xxx;
> describe tables;
...
```

良さそう

## 公式のツールは...?

今回ローカルでテストするだけだったので、 `cassandradump` でのダンプを行ったが、本番環境等でオペレーションするときは公式の `nodetool` を使用するのがいいらしい。

cassandraを導入しなくても [ここ](https://academy.datastax.com/planet-cassandra/cassandra) からインストールできる。
正直「download cassandra」とか検索してもこのサイトが引っかからなくて辛かった。