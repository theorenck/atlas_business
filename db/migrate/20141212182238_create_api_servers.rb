class CreateAPIServers < ActiveRecord::Migration
  def change
    create_table :api_servers do |t|
      t.string :name
      t.string :description
      t.string :url
      t.integer :status
      t.timestamps
    end
  end
end
