class CreateInstructors < ActiveRecord::Migration[7.0]
  def change
    create_table :instructors do |t|
      t.string :instructor_id
      t.string :name
      t.string :email
      t.string :password
      t.string :department

      t.timestamps
    end
    add_index :instructors, :instructor_id, unique: true
  end
end
