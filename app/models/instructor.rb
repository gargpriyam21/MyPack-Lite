class Instructor < ApplicationRecord
  has_secure_password
  has_many :students
  has_many :courses, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  belongs_to :user, dependent: :destroy
end
