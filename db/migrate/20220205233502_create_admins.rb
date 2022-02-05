class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :admin_id
      t.string :password
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
    add_index :admins, :admin_id, unique: true
  end
end
