class AddNewColumnsToBuild < ActiveRecord::Migration
  def self.up
    add_column :builds, :author, :string
    add_column :builds, :commit, :string
    add_column :builds, :comment, :string
  end

  def self.down
  end
end
