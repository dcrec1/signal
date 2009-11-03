class AddBranchToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :branch, :string
  end

  def self.down
  end
end
