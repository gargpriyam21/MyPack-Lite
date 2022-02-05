class CreateWaitlists < ActiveRecord::Migration[7.0]
  def change
    create_table :waitlists do |t|
      t.string :student_id
      t.string :course_id

      t.timestamps
    end
  end
end
