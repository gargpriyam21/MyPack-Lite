class Student < ApplicationRecord
  belongs_to :user
  has_many :courses
  has_many :enrollments
end
