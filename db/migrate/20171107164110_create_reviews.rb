class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.date :rw_date
      t.string :rw_file

      t.timestamps
    end
  end
end
