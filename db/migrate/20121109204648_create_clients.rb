class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :username
      t.string :encrypted_password
      t.string :encrypted_password_confirmation
      t.string :remember_token
	  t.string :country


      t.timestamps
    end
  end
end
