class AddDeployToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :deploy_command, :string, :default => "rake inploy:remote:update"
  end

  def self.down
    remove_column :projects, :deploy_command
  end
end
