class AddUrlTripadvisorToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :url_tripadvisor, :string, null: false, comment: "tripadvisorURL"
  end
end
