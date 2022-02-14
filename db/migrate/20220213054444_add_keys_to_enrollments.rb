class AddKeysToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_reference :enrollments, :course, null: false, foreign_key: true
    add_reference :enrollments, :student, null: false, foreign_key: true
    add_reference :enrollments, :instructor, null: false, foreign_key: true
  end
end
