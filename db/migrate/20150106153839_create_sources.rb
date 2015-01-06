class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :type
      
      t.string :name
     
      t.text    :statement
      t.integer :limit
      t.integer :offset

      t.string :result      
      t.references :query, index: true
      
      t.timestamps
    end
  end
end
