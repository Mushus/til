# clasp

## 手順

1. [ここ](https://script.google.com/home/usersettings) からGoogle Apps Script APIを許可する
1. プロジェクトを作成する
1. コードを追加する
1. コードをかく
1. デプロイする

### プロジェクトを作成する

```
# プロジェクトディレクトリ作成
mkdir clasp-hoge
cd clasp-hoge
# プロジェクト初期化
yarn init
# 依存関係追加
yarn add -D @google/clasp tslint @types/google-apps-script
# tslint初期化
./node_modules/.bin/tslint --init
# claspのログイン(多分最初のみ)
./node_modules/.bin/clasp login
# claspプロジェクト作成
./node_modules/.bin/clasp create clasp-ts-sample --rootDir ./src
# ドライブに作成されたGASをpullしてくる
./node_modules/.bin/clasp pull
```

### コードを追加する

```
touch ./src/Code.ts
```

### デプロイする

```
clasp push
```