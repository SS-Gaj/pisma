class AddLkFileToOverlooks < ActiveRecord::Migration
  def change
    add_column :overlooks, :lk_file_g, :string
    add_column :overlooks, :lk_file_o, :string
  end
end
