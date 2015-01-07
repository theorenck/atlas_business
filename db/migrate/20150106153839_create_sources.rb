class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :type
      
      t.string :name
     
      t.text    :statement
      t.integer :limit
      t.integer :offset

      t.string :result      
      
      t.timestamps
    end
    
    create_table :aggregations_sources do |t|
      t.integer :aggregation_id
      t.integer :source_id
      t.timestamps
    end

    add_index(:aggregations_sources, [:aggregation_id, :source_id], :unique => true)
  end
end
