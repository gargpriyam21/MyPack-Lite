class Course < ApplicationRecord
  has_one :instructor
  has_many :enrollments, dependent: :destroy
  has_many :students
  belongs_to :student, optional: true
  belongs_to :instructor

  # validates :waitlist_capacity ,presence: true
  validates :course_code, presence: true, uniqueness: true
  validates :name,:description,:weekdays,:start_time,:end_time,:capacity,:room ,presence: true
  # validates :end_time, comparison: { greater_than: :start_time }
end
