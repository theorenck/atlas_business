class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :name
      t.string :description
      
      t.references :source, polymorphic: true, index: true
      t.references :unity, index: true
      
      t.timestamps
    end
  end
end
