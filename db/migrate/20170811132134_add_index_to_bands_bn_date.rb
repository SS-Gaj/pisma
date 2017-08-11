class AddIndexToBandsBnDate < ActiveRecord::Migration
  def change
	add_index :bands, :bn_date
  end
end
