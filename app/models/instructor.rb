class Instructor < ApplicationRecord
  has_secure_password
  has_many :students
  has_many :courses
  validates :email_address, presence: true, uniqueness: true
end
