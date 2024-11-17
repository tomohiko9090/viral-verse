class AddFeedbackFieldsToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :feedback1, :text
    add_column :reviews, :feedback2, :text
  end
end
