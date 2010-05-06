class AddBuildCommandToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :build_command, :string, :default => "rake build"
  end

  def self.down
    remove_column :projects, :build_command
  end
end
