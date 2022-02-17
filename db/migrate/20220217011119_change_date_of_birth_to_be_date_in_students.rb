class ChangeDateOfBirthToBeDateInStudents < ActiveRecord::Migration[7.0]
  def up
    change_column :students, :date_of_birth, :date
  end

  def down
    change_column :students, :date_of_birth, :datetime
  end
end
