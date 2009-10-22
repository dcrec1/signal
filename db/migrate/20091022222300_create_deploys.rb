class CreateDeploys < ActiveRecord::Migration
  def self.up
    create_table :deploys do |t|
      t.references :project
      t.text :output
      t.boolean :success

      t.timestamps
    end
  end

  def self.down
    drop_table :deploys
  end
end
