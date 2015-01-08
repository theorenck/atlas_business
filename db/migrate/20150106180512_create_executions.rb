class CreateExecutions < ActiveRecord::Migration
  def change
    create_table :executions do |t|
      t.integer :order
      t.references :aggregation
      t.references :function
      t.timestamps
    end
  end
end
