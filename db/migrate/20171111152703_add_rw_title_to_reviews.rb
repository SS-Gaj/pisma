class AddRwTitleToReviews < ActiveRecord::Migration
  def change
      add_column :reviews, :rw_title, :string
  end
end
