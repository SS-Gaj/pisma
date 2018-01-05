class AddDatefactToFacts < ActiveRecord::Migration
  def change
    add_column :facts, :fc_date, :datetime
  end
end
