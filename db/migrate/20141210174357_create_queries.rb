class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :type
      t.text :statement
      t.timestamps
    end
  end
end
