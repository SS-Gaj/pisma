class AddIsxurlToFacts < ActiveRecord::Migration
  def change
    add_column :facts, :fc_isxurl, :string
  end
end
