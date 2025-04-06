class AddUserIdToReviews < ActiveRecord::Migration[7.1]
  def up
    add_reference :reviews, :user, null: true, foreign_key: true, after: :shop_id, comment: "ユーザーID（users.id）、未ログイン時はnull"
  end

  def down
    # 外部キー制約を先に削除
    if foreign_key_exists?(:reviews, :users)
      remove_foreign_key :reviews, :users
    end

    # その後、カラムとインデックスを削除
    if index_exists?(:reviews, :user_id)
      remove_index :reviews, :user_id
    end

    if column_exists?(:reviews, :user_id)
      remove_column :reviews, :user_id
    end
  end
end