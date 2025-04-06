class ChangeShopUrlColumnType < ActiveRecord::Migration[6.1]
  def up
    remove_index :shops, name: "index_shops_on_url"

    # VARCHAR(255)からTEXT型に変更
    change_column :shops, :url, :text, comment: "google URL"
    change_column :shops, :url_tripadvisor, :text, comment: "tripadvisor URL"

    # TEXT型に適したインデックスを再作成（最初の255文字をインデックス化）
    add_index :shops, :url, name: "index_shops_on_url", unique: true, length: 255
  end

  def down
    remove_index :shops, name: "index_shops_on_url"

    # 元に戻す場合のコード
    change_column :shops, :url, :string, comment: "google URL"
    change_column :shops, :url_tripadvisor, :string, comment: "tripadvisor URL"

    # 元のインデックスを再作成
    add_index :shops, :url, name: "index_shops_on_url", unique: true
  end
end