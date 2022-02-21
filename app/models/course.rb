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
  validates :name, :description, :weekday1, :start_time, :end_time, :capacity, :waitlist_capacity, :room, presence: true
  validates :weekday2, allow_blank: true, comparison: { other_than: :weekday1 }, presence: false
  # validates :start_time, :end_time, format: {
  #   with: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
  #   message: "Invalid Time format",
  #   multiline: true
  # }

  validates :course_code, format: {
    with: /^[A-Za-z]{0,3}[0-9]{3}$/,
    message: "is Invalid",
    multiline: true
  }

  validate :check_start_and_end_date

  def check_start_and_end_date
    if !start_time.to_s.match(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/)
      errors.add(:start_time, "Invalid Time format")
    elsif !end_time.to_s.match(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/)
      errors.add(:end_time, "Invalid Time format")
    elsif DateTime.strptime(end_time.to_s, '%H:%M') < DateTime.strptime(start_time.to_s, '%H:%M')
      errors.add(:end_time, "can't be less than Start Time")
    end
  end

  # validates DateTime.strptime(end_time.to_s,'%H:%M'), comparison: {greater_than: DateTime.strptime(start_time.to_s,'%H:%M')}
end
