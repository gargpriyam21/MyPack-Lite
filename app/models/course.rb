class Course < ApplicationRecord
  has_one :instructor
  has_many :enrollments, dependent: :destroy
  has_many :students
  belongs_to :student, optional: true
  belongs_to :instructor
end
