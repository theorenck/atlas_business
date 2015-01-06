class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :dashboard, index: true
      t.references :data_source_server, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
