class MasterIsTheDefaultBranch < ActiveRecord::Migration
  def self.up
    change_column :projects, :branch, :string, :default => 'master'
  end

  def self.down
    change_column :projects, :branch
  end
end
