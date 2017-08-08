class AddUrlToBands < ActiveRecord::Migration
  def change
    add_column :bands, :bn_url, :string
  end
end
