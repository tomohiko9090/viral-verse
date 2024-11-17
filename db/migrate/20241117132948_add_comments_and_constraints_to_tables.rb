class AddCommentsAndConstraintsToTables < ActiveRecord::Migration[7.1]
  def change
    # reviewsテーブルの変更
    change_table_comment :reviews, 'レビュー情報を管理するテーブル'

    change_column_null :reviews, :score, false
    change_column_null :reviews, :comments, false

    change_column_comment :reviews, :shop_id, '店舗ID（shops.id）'
    change_column_comment :reviews, :score, '評価点数（1-5）'
    change_column_comment :reviews, :comments, 'レビューコメント（最大1000文字）'
    change_column_comment :reviews, :feedback1, 'アンケート回答1（評価1-3の場合）'
    change_column_comment :reviews, :feedback2, 'アンケート回答2（評価1-3の場合）'
    change_column_comment :reviews, :created_at, '作成日時'
    change_column_comment :reviews, :updated_at, '更新日時'
    change_column_comment :reviews, :deleted_at, '論理削除日時'

    # reviewsのカラム順序変更
    change_column :reviews, :shop_id, :bigint, null: false, after: :id
    change_column :reviews, :score, :integer, null: false, after: :shop_id
    change_column :reviews, :comments, :text, null: false, after: :score
    change_column :reviews, :feedback1, :text, after: :comments
    change_column :reviews, :feedback2, :text, after: :feedback1
    change_column :reviews, :created_at, :datetime, null: false, after: :feedback2
    change_column :reviews, :updated_at, :datetime, null: false, after: :created_at
    change_column :reviews, :deleted_at, :datetime, after: :updated_at

    # shopsテーブルの変更
    change_table_comment :shops, '店舗情報を管理するテーブル'

    change_column_null :shops, :name, false
    change_column_null :shops, :url, false

    # uniqueインデックスの追加（urlカラム）
    remove_index :shops, :url if index_exists?(:shops, :url)
    add_index :shops, :url, unique: true

    change_column_comment :shops, :name, '店舗名'
    change_column_comment :shops, :url, '店舗URL（一意）'
    change_column_comment :shops, :qr_code, 'QRコードの保存パス'
    change_column_comment :shops, :created_at, '作成日時'
    change_column_comment :shops, :updated_at, '更新日時'
    change_column_comment :shops, :deleted_at, '論理削除日時'

    # shopsのカラム順序変更
    change_column :shops, :name, :string, null: false, after: :id
    change_column :shops, :url, :string, null: false, after: :name
    change_column :shops, :qr_code, :string, after: :url
    change_column :shops, :created_at, :datetime, null: false, after: :qr_code
    change_column :shops, :updated_at, :datetime, null: false, after: :created_at
    change_column :shops, :deleted_at, :datetime, after: :updated_at

    # usersテーブルの変更
    change_table_comment :users, 'ユーザー情報を管理するテーブル'

    change_column_comment :users, :name, 'ユーザー名'
    change_column_comment :users, :email, 'メールアドレス（一意）'
    change_column_comment :users, :password_digest, 'パスワードハッシュ（6文字以上）'
    change_column_comment :users, :role, 'ユーザー権限（1:admin管理者, 2:owner店舗オーナー）'
    change_column_comment :users, :language_id, '言語ID（1:日本語）'
    change_column_comment :users, :shop_id, '所属店舗ID（shops.id）'
    change_column_comment :users, :created_at, '作成日時'
    change_column_comment :users, :updated_at, '更新日時'
    change_column_comment :users, :deleted_at, '論理削除日時'

    # usersのカラム順序変更
    change_column :users, :name, :string, null: false, after: :id
    change_column :users, :email, :string, null: false, after: :name
    change_column :users, :password_digest, :string, null: false, after: :email
    change_column :users, :role, :integer, null: false, default: 2, after: :password_digest
    change_column :users, :language_id, :integer, null: false, default: 1, after: :role
    change_column :users, :shop_id, :integer, after: :language_id
    change_column :users, :created_at, :datetime, null: false, after: :shop_id
    change_column :users, :updated_at, :datetime, null: false, after: :created_at
    change_column :users, :deleted_at, :datetime, after: :updated_at
  end
end
