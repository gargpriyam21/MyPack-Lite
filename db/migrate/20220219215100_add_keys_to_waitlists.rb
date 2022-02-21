class AddKeysToWaitlists < ActiveRecord::Migration[7.0]
  def change
    add_reference :waitlists, :course, null: false, foreign_key: true
    add_reference :waitlists, :student, null: false, foreign_key: true
    add_reference :waitlists, :instructor, null: false, foreign_key: true
  end
end
