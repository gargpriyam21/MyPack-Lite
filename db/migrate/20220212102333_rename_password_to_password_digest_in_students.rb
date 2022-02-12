class RenamePasswordToPasswordDigestInStudents < ActiveRecord::Migration[7.0]
  def up
    rename_column :students, :password, :password_digest
    rename_column :instructors, :password, :password_digest
    rename_column :admins, :password, :password_digest
  end

  def down
    rename_column :students, :password_digest, :password
    rename_column :instructors, :password_digest, :password
    rename_column :admins, :password_digest, :password
  end
end
