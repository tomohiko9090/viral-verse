class CreateShopUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_users, comment: "ユーザーと店舗の中間テーブル" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID（users.id）"
      t.references :shop, null: false, foreign_key: true, comment: "店舗ID（shops.id）"

      t.timestamps
      t.datetime :deleted_at, comment: "論理削除日時"

      t.index [:user_id, :shop_id], unique: true
      t.index :deleted_at
    end
  end
end
