class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :instructor_name
      t.string :weekdays
      t.string :start_time
      t.string :end_time
      t.string :course_code
      t.integer :capacity
      t.integer :students_enrolled
      t.integer :waitlist_capacity
      t.integer :students_waitlisted
      t.string :status
      t.string :room

      t.timestamps
    end
    add_index :courses, :course_code, unique: true
  end
end
