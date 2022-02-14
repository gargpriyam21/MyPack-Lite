class RenameNamesInEnrollments < ActiveRecord::Migration[7.0]
  def up
    rename_column :enrollments, :student_id, :student_code
    rename_column :enrollments, :course_id, :course_code
  end

  def down
    rename_column :enrollments, :student_code, :student_id
    rename_column :enrollments, :course_code, :course_id
  end
end
