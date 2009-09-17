class RenameBuildsLogColumnToOutput < ActiveRecord::Migration
  def self.up
    rename_column :builds, :log, :output
  end

  def self.down
  end
end
