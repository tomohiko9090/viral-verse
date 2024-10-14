class AddDeletedAtToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :deleted_at, :datetime
    add_index :shops, :deleted_at
  end
end
