class CreateBuilds < ActiveRecord::Migration
  def self.up
    create_table :builds do |t|
      t.references :project
      t.text :log
      t.boolean :success

      t.timestamps
    end
  end

  def self.down
    drop_table :builds
  end
end
