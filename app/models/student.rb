class Student < ApplicationRecord
  has_secure_password
  belongs_to :user, dependent: :destroy
  has_many :courses
  has_many :enrollments, dependent: :destroy

  validates :name, :password_digest, :date_of_birth, :phone_number, :major, presence: true

  validates :email, :student_id, presence: true, uniqueness: true

  validates :phone_number, format: {
                      with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/,
                      message: "Not a valid Phone Number"
  }

  validates :email, format: {
                      with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
                      message: "Invalid Email",
                      multiline: true
  }
end
