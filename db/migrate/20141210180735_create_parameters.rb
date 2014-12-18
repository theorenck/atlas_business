class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name
      t.string :data_type
      t.string :default_value
      t.references :query, index: true
      t.timestamps
    end
  end
end
