class CreateBitcoins < ActiveRecord::Migration
  def change
    create_table :bitcoins do |t|
      t.datetime :btc_date
      t.string :btc_head
      t.string :btc_novelty
      t.string :btc_url

      t.timestamps
    end
  end
end
