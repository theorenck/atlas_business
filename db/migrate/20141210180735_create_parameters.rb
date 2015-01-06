class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :type

      t.string :name
      t.string :value
      t.string :datatype
      t.boolean :evaluated
      
      t.references :parameterizable, polymorphic: true, index: true
      t.references :function, index: true
      
      t.timestamps
    end
  end
end

