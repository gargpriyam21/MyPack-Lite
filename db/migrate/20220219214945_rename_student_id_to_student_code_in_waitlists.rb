class RenameStudentIdToStudentCodeInWaitlists < ActiveRecord::Migration[7.0]
  def up
    rename_column :waitlists, :student_id, :student_code
    rename_column :waitlists, :course_id, :course_code
  end

  def down
    rename_column :waitlists, :student_code, :student_id
    rename_column :waitlists, :course_code, :course_id
  end
end
