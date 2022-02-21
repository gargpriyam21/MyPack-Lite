require 'date'

class Course < ApplicationRecord
  has_one :instructor
  has_many :enrollments, dependent: :destroy
  has_many :students
  belongs_to :student, optional: true
  belongs_to :instructor
  has_many :waitlists, dependent: :destroy

  # validates :waitlist_capacity ,presence: true
  validates :course_code, presence: true, uniqueness: true
  # validates :weekday2, presence: false
  validates :name, :description, :weekday1, :start_time, :end_time, :capacity,:waitlist_capacity, :room, presence: true
  validates :weekday2,allow_blank: true, comparison: { other_than: :weekday1 }, presence: false
  validates :start_time,:end_time, format: {
    with: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
    message: "Invalid Time format",
    multiline: true
  }

  validates :course_code, format: {
    with: /^[A-Za-z]{0,3}[0-9]{3}$/,
    message: "Invalid Course Code",
    multiline: true
  }




  # validates DateTime.strptime(:end_time.to_s,'%H:%M'), comparison: {greater_than: DateTime.strptime(:start_time.to_s,'%H:%M')}
end
