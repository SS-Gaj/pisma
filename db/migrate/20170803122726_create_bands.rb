class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :bn_head
      t.string :novelty
      t.datetime :bn_date

      t.timestamps
    end
  end
end
