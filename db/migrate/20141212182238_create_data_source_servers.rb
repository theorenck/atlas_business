class CreateDataSourceServers < ActiveRecord::Migration
  def change
    create_table :data_source_servers do |t|
      t.string :name
      t.string :description
      t.string :url
      t.boolean :alive
      t.timestamps
    end
  end
end
