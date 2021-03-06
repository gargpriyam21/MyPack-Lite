class Student < ApplicationRecord
  has_secure_password
  belongs_to :user, dependent: :destroy
  has_many :courses
  has_many :enrollments, dependent: :destroy
  has_many :waitlists, dependent: :destroy

  validates :email, :student_id, presence: true, uniqueness: true
  validates :name, :password_digest, :date_of_birth, :phone_number, :major, presence: true

  validates :phone_number, format: {
    with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/,
    message: "Not Valid"
  }

  validates :email, format: {
    with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
    message: "is Invalid",
    multiline: true
  }
end
