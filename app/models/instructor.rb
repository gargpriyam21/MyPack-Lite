class Instructor < ApplicationRecord
  has_secure_password
  has_many :students
  has_many :courses, dependent: :destroy
  validates :email,:instructor_id, presence: true, uniqueness: true
  belongs_to :user, dependent: :destroy
  validates :name, :password_digest, :department, presence: true

  validates :email, format: {
    with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
    message: "Invalid Email",
    multiline: true
  }
end
