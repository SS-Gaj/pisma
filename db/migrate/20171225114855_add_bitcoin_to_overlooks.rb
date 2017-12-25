class AddBitcoinToOverlooks < ActiveRecord::Migration
  def change
    add_column :overlooks, :lk_btcfile, :string
  end
end
