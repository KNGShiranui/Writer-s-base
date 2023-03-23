# README

## 開発言語
- Ruby3.0.1
- Rails6.1.6

## 就業Termの技術
- devise
- 1対1のメッセージ機能（もしくは友だち繋がり機能）

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
  https://github.com/KNGShiranui/Writer-s-base/blob/introduction_of_devise/image/ER%E5%9B%B3.png
## ワイヤーフレーム
  https://drive.google.com/drive/folders/10IG6nYSs7ahhPLE9sYMJM020ar3YJcC7
## 画面遷移図
  https://docs.google.com/spreadsheets/d/1qV1A6FU7vy2-N8xqLOxNf0yL5Fnsz7u3/edit#gid=30523286
  https://drive.google.com/drive/folders/1sOazQZBQBend8XAyl8gvdrPYHXzCLoov