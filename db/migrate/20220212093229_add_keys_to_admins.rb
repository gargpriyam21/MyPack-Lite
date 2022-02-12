class AddKeysToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_reference :admins, :user, null: false, foreign_key: true
  end
end
