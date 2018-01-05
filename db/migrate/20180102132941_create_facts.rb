class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.string :fc_range
      t.string :fc_fact
      t.string :fc_myurl
      t.integer :fc_idurl

      t.timestamps
    end
  end
end
