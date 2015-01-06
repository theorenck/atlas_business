class CreateUnities < ActiveRecord::Migration
  def change
    create_table :unities do |t|
      t.string :name
      t.string :symbol

      t.timestamps
    end
  end
end
