class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
    add_index :shops, :url
  end
end
