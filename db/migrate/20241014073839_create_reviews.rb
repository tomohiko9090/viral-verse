class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :shop, null: false, foreign_key: true
      t.integer :score
      t.text :comments

      t.timestamps
    end
  end
end
