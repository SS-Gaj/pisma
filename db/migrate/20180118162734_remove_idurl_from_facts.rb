class RemoveIdurlFromFacts < ActiveRecord::Migration
  def change
    remove_column :facts, :fc_idurl, :integer
  end
end
