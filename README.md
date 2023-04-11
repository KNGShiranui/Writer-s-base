# README

## 開発言語
- Ruby3.0.1
- Rails6.1.6

## 就業Termの技術
- devise
- 1対1のメッセージ機能（もしくは友だち繋がり機能）
- cancancan
- rails_admin

## カリキュラム外の技術
- paper_trail
- Trix
- Active Storage
- markdiff

## 実行手順
- git clone git@github.com:KNGShiranui/repository_manager_1.git
- cd repository_manager_1
- bundle install
- bundle exec rails generate paper_trail:install --with-changes
- bin/rails db:migrate
- rails generate devise:install
- rails db:create && rails db:migrate
- yarn add trix

## カタログ設計
  https://docs.google.com/spreadsheets/d/1qV1A6FU7vy2-N8xqLOxNf0yL5Fnsz7u3/edit#gid=365249127
## テーブル定義書
  https://docs.google.com/spreadsheets/d/1qV1A6FU7vy2-N8xqLOxNf0yL5Fnsz7u3/edit#gid=1153070755
## ER図
  ![ER図](https://github.com/KNGShiranui/Writer-s-base/blob/rails_admin/image/ER%E5%9B%B3%EF%BC%88%E6%94%B9%EF%BC%89.png)
## ワイヤーフレーム
  https://drive.google.com/drive/folders/10IG6nYSs7ahhPLE9sYMJM020ar3YJcC7
## 画面遷移図
  ![画面遷移図](https://github.com/KNGShiranui/Writer-s-base/blob/introduction_of_devise/image/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3.png)


## 開発時の補足
  # テスト実施時に以下のエラー
    Webpacker can't find application.js
    Webpacker::Manifest::MissingEntryError at /users/sign_up
    Webpacker can't find application.js in /home/kengo/workspace/Writer-s-base/public/packs-test/manifest.json. Possible causes:
  # 原因：テスト環境においてasset:precompileがなされておらず、packs-testディレクトリ以下の必要なファイルが存在しなかった。
  # 解決策：rails assets:precompile RAILS_ENV=testを実行
  # 以下のコマンドも何か関係があるかも・・・？
    echo $SHELL
    vi ~/.zshrc（以下を追加）
    　export EDITOR="code --wait"
      export BETTER_ERRORS_EDITOR="$EDITOR"
    source ~/.zshrc

## テスト実施時の不具合
  # bundle exec rspecとbin/rspecの違い
    基本はbundle exec rspecの方がいい。余計なバージョン間の衝突を回避できる。