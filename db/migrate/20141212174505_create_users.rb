class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :token
      t.boolean :admin #temporary flag
      t.timestamps
    end
  end
end
