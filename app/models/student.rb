class Student < ApplicationRecord
  has_secure_password
  belongs_to :user
  has_many :courses
  has_many :enrollments
end
