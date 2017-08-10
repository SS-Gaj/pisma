class AddIndexToBandsCreatedAt < ActiveRecord::Migration
  def change
	add_index :bands, :created_at
  end
end
