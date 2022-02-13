class Instructor < ApplicationRecord
  has_secure_password
  has_many :students
  has_many :courses
  validates :email, presence: true, uniqueness: true
  belongs_to :user
end
