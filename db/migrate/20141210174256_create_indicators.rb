class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :unity
      t.string :name
      t.string :description
      t.references :query, index: true
      t.string :type
      t.timestamps
    end
  end
end
