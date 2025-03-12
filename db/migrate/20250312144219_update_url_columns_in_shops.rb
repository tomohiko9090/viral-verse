class UpdateUrlColumnsInShops < ActiveRecord::Migration[7.1]
  def up
    change_column :shops, :url, :string, null: true, comment: "google URL"
    change_column :shops, :url_tripadvisor, :string, null: true, comment: "tripadvisor URL", after: :url
  end

  def down
    change_column :shops, :url, :string, null: false, comment: "店舗URL（一意）"
  end
end
