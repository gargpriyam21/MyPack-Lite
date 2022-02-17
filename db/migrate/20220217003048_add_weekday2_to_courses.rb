class AddWeekday2ToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :weekday2, :string
  end
end
