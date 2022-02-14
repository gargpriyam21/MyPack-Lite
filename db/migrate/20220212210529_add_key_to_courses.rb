class AddKeyToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :instructor, null: false, foreign_key: true
  end
end
