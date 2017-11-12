class AddRwArticleToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rw_article, :text
  end
end
