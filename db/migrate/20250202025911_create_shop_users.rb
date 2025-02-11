class CreateShopUsers < ActiveRecord::Migration[7.1]
  def change
    # 新しいテーブルを作成
    create_table :shop_users do |t|
      t.bigint :shop_id, null: false, comment: "店舗ID（shops.id）"
      t.bigint :user_id, null: false, comment: "ユーザーID（users.id）"
      t.datetime :deleted_at, comment: "論理削除日時"
      t.timestamps null: false

      t.index [:shop_id, :user_id], unique: true
      t.index :deleted_at
      t.index :shop_id
      t.index :user_id

      t.foreign_key :shops
      t.foreign_key :users
    end

    # 既存のユーザーと店舗の紐付けを移行
    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO shop_users (shop_id, user_id, created_at, updated_at)
          SELECT shop_id, id, created_at, updated_at
          FROM users
          WHERE shop_id IS NOT NULL
        SQL
      end
    end

    # users.shop_idカラムを削除
    remove_column :users, :shop_id, :integer
  end
end