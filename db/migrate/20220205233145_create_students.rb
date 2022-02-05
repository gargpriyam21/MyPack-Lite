class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :student_id
      t.string :email
      t.string :password
      t.datetime :date_of_birth
      t.string :phone_number
      t.string :major

      t.timestamps
    end
    add_index :students, :student_id, unique: true
  end
end
