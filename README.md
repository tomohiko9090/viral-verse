# 暫定デプロイ手順
1. ssh -i ~/.ssh/***REMOVED*** ec2-user@***REMOVED***
2. cd /var/www/kuchikomi-elevator
3. git pull origin main
4. 以下実行
```
RAILS_ENV=production bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails assets:clobber
RAILS_ENV=production bundle exec rails assets:precompile
kill -QUIT `cat tmp/pids/unicorn.pid`
RAILS_ENV=production bundle exec unicorn_rails -c config/unicorn.rb -E production -D
```

# ユーザー権限と機能アクセス

| ユーザー権限 | 利用者 | アクセス範囲 | ShopsController | ReviewsController |
|-------------|------------|------------|-----------------|-------------------|
| admin       | 開発者・運用者 | すべてのお店 | すべて            | すべて              |
| owner       | オーナー・店長・店員 | 特定のお店   | show, edit, update | すべて              |
| customer    | お店に来たお客さん | 特定のお店   | アクセス不可           | new, create, notice |


# DB
https://drawsql.app/teams/--109/diagrams/kuchikomi-elevator-2

# アンケートのフローチャート
```mermaid
flowchart TD
    qr(QRコード表示) --> |fa:fa-user スマホで読みとる|review[評価ページに遷移]
    review --> |fa:fa-user 回答する|branch{レビューを投稿ボタンをクリック後、★の数で分岐}

    branch -->|1~3個の場合| survey1[改善点についてのアンケート]
    branch -->|4,5個の場合| copy[レビューありがとうございます!でコメントをコピー]

    survey1 --> |fa:fa-user 回答する|survey2[サービス改善のご提案についてのアンケート]
    survey2 -->|fa:fa-user 回答する|thanks[フィードバックありがとうございました]
    
    copy --> Google
    thanks -->Google(Google口コミ画面に遷移)
```

# 設計方針
- enum
  - 権限
- アクティブハッシュ
  - 言語設定
- テーブル管理、縦持ち
  - 業界
- カラム追加、横持ち
  - お店名
- i18n
  - いろんなページの文言
- 定数

 
# AWS アーキテクチャ提案（コスト順）
1ヶ月、1日300リクエストの場合を想定

## 1. 最小コスト構成
Route 53 → EC2 (t3.micro) [スポットインスタンス] → MySQL(EC2内) → S3
Copy- **月額コスト：約¥900（$6）**
- **主な用途：開発初期、MVP、小規模運用**
### 特徴
- EC2内にMySQLを直接インストール
- スポットインスタンスによるコスト削減
- シンプルな構成で管理が容易
### デメリット
- DBの冗長性なし
- スポットインスタンスは中断の可能性あり
- スケーリングは手動

→ S3にバックアップを取ることも可能

## 2. 標準構成（EC2 + RDS）
Route 53 → EC2 (t3.micro) → RDS (t3.micro) → S3
Copy- **月額コスト：約¥3,750（$25）**
- **主な用途：小～中規模のプロダクション環境**
### 特徴
- RDSによる堅牢なDB運用
- バックアップ・復元が容易
- 管理が比較的容易
### デメリット
- コストが中程度
- スケーリングは手動
- 運用管理の工数が必要

## 3. サーバーレス構成
Route 53 → API Gateway → Lambda → Aurora Serverless v2 → S3
Copy- **月額コスト：約¥6,150（$41）**
- **主な用途：変動の大きいワークロード、運用工数を最小化したい場合**
### 特徴
- サーバー管理不要
- 自動スケーリング
- 高可用性
### デメリット
- 最もコストが高い
- 初期構築が複雑
- コールドスタートの問題

## 選定の指針
1. **開発初期・検証フェーズ**
   - 最小コスト構成を推奨
   - コストを抑えながら機能検証が可能

2. **本番運用開始時**
   - 標準構成への移行を検討
   - データの永続性と運用の安定性を確保

3. **スケール時・運用効率化時**
   - サーバーレス構成への移行を検討
   - トラフィック変動への対応と運用負荷の軽減

## 注意点
- すべての構成で、AWS無料枠の活用が可能
- トラフィック増加に応じて、上位構成への移行を検討
- セキュリティとバックアップは全構成で考慮が必要


# DBバックアップ戦略
## EBSスナップショットの自動バックアップ設定手順

	1.	AWSマネジメントコンソールにアクセス：
	•	AWSコンソールにサインインし、「EC2」サービスを開きます。
	2.	ライフサイクルマネージャーの設定：
	•	EC2ダッシュボードの左メニューから「ライフサイクルマネージャー（Lifecycle Manager）」を選択します。
	3.	ライフサイクルポリシーの作成：
	•	「ポリシーの作成（Create Lifecycle Policy）」ボタンをクリックします。
	4.	ポリシーの設定：
	•	以下の項目を設定します。
	•	ポリシータイプ：EBSスナップショットを選択します。
	•	リソースタイプ：バックアップを取りたいEBSボリュームのタイプを選びます。
	•	タグ：特定のボリュームだけをバックアップしたい場合、タグを指定してフィルタリングします。
	5.	スケジュールの設定：
	•	「スケジュールの追加」をクリックし、以下の内容を設定します。
	•	頻度：毎日を選択。
	•	開始時間：バックアップを取りたい時間を指定（たとえば毎日深夜2時など）。
	•	保持期間：バックアップを何日分保持するかを指定します（例えば30日分保持など）。
	6.	ポリシーを有効化：
	•	設定を確認し、「ポリシーを作成（Create Policy）」をクリックして完了です。

## 毎日自動でEBSスナップショットを取る手順
	1.	AWSマネジメントコンソールにアクセス：
	•	AWSにサインインし、「EC2」サービスに移動します。
	2.	Data Lifecycle Managerの設定ページにアクセス：
	•	左のメニューで「ライフサイクルマネージャー（Lifecycle Manager）」を選択します。
	3.	ライフサイクルポリシーの作成：
	•	「ポリシーの作成（Create lifecycle policy）」をクリックします。
	4.	ポリシーの設定：
	•	ポリシーの内容を設定していきます。
	•	ポリシータイプ：EBSスナップショットを選択。
	•	リソースタイプ：ボリュームを選択。
	•	タグ指定：特定のボリュームだけバックアップしたい場合は、該当するボリュームのタグを指定します。
	5.	スケジュールの設定：
	•	「スケジュールの追加」をクリックし、スナップショットのスケジュールを設定します。
	•	頻度：毎日を選択。
	•	開始時間：バックアップの実行時間を指定します（例：深夜2時）。
	•	保持期間：スナップショットを何日間保存するか設定します（例：30日）。
	6.	ポリシーの有効化：
	•	設定内容を確認し、「ポリシーを作成」をクリックして完了です。


# 他の開発者がプロジェクトを設定する際の設定
```shell
# リポジトリをクローン
git clone [リポジトリURL]

# プロジェクトディレクトリに移動
cd [プロジェクト名]

# .env.exampleを.envにコピー
cp ./.env.example ./.env

# 依存関係をインストール
bundle install

# データベースをセットアップ
bin/rails db:create
bin/rails db:migrate
```


# ログ
## Unicornのエラーログを確認
tail -f /var/www/kuchikomi-elevator/log/unicorn.stderr.log

## Unicornの標準出力ログを確認
tail -f /var/www/kuchikomi-elevator/log/unicorn.stdout.log

## Railsのプロダクションログを確認
tail -f /var/www/kuchikomi-elevator/log/production.log

## システムログも確認
sudo tail -f /var/log/messages

## Nginxのエラーログ
sudo tail -f /var/log/nginx/error.log

## フロント読み込み
- app/javascript/application.js
  - 起点となるファイル
- app/javascript/controllers/index.js
  - 読み込むファイル
- config/importmap.rb
  - モジュールをどこから読み込むかを定義するファイル
  - pin "application" と書くと、app/javascript/application.jsを読み込めるようになる
- app/javascript/controllers/application.js
	- StimulusのApplicationインスタンスを作成・設定
	- インスタンスを他のファイルで使えるようexport
	- デバッグ設定なども行う


```mermaid
graph TD
    A[importmap.rb] -->|1. モジュールのマッピング| B[application.js]
    B -->|2. controllers読み込み| C[controllers/index.js]
    C -->|3. Stimulus初期化| D[controllers/application.js]
    D -->|4. Stimulusアプリケーション提供| C
```

```
<script type="importmap">
にある順番で
curl -k https://***REMOVED***/shops/1/reviews/new
の順番で読み込まれていく
```

- JSやCSSの変更 → アセット関連コマンドとUnicornの再起動
```
RAILS_ENV=production bundle exec rails assets:clean    # 古いアセットを削除
RAILS_ENV=production bundle exec rails assets:clobber  # アセットを完全に削除
RAILS_ENV=production bundle exec rails assets:precompile # アセットを再コンパイル
```
- アプリケーションコードの変更 → Unicornの再起動のみ
	- ex.mainブランチをpullした後やUnicornの設定を大きく変更した時
```
kill -QUIT `cat tmp/pids/unicorn.pid` && \
RAILS_ENV=production bundle exec unicorn_rails -c config/unicron.rb -E production -D
```
- Nginx設定の変更 → Nginxの再起動のみ
	- ex./etc/nginx/conf.d/rails.conf などのNginx設定ファイルを変更した時
```
sudo systemctl restart nginx
```