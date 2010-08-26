class AddBuildingToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :building, :boolean
  end

  def self.down
    remove_column :projects, :building
  end
end
