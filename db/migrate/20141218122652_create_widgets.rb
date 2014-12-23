class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :color
      t.integer :position
      t.integer :size
      t.string :name
      t.string :description
      t.boolean :customized
      t.references :dashboard, index: true
      t.references :indicator, index: true
      t.references :widget_type, index: true
      t.timestamps
    end
  end
end
