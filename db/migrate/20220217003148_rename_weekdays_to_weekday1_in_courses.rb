class RenameWeekdaysToWeekday1InCourses < ActiveRecord::Migration[7.0]
  def up
    rename_column :courses, :weekdays, :weekday1
  end

  def down
    rename_column :courses, :weekday1, :weekdays
  end
end
