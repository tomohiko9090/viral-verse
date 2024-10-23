# KuchikomiElevator

## ユーザー権限と機能アクセス

| ユーザー権限 | 利用者 | アクセス範囲 | ShopsController | ReviewsController |
|-------------|------------|------------|-----------------|-------------------|
| admin       | 開発者・運用者 | すべてのお店 | すべて            | すべて              |
| owner       | オーナー・店長・店員 | 特定のお店   | show, edit, update | すべて              |
| customer    | お店に来たお客さん | 特定のお店   | アクセス不可           | new, create, notice |


## DB
https://drawsql.app/teams/--109/diagrams/kuchikomi-elevator-2

## 設計方針
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

