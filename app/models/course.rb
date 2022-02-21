require 'date'

class Course < ApplicationRecord
  has_one :instructor
  has_many :enrollments, dependent: :destroy
  has_many :students
  belongs_to :student, optional: true
  belongs_to :instructor
  has_many :waitlists, dependent: :destroy

  validates :course_code, presence: true, uniqueness: true
  validates :name, :description, :weekday1, :start_time, :end_time, :capacity, :waitlist_capacity, :room, presence: true
  validates :weekday2, allow_blank: true, comparison: { other_than: :weekday1 }, presence: false

  validates :course_code, format: {
    with: /^[A-Za-z]{0,3}[0-9]{3}$/,
    message: "is Invalid",
    multiline: true
  }

  validate :weekday1_and_weekday2
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

  def weekday1_and_weekday2
    weekday_hash = { "MON" => 1, "TUE" => 2, "WED" => 3, "THU" => 4, "FRI" => 5, nil => 6 }
    if weekday1 == 'FRI' and !weekday2.nil?
      errors.add(:weekday2, "must be blank if Weekday 1 is FRI")
    elsif weekday_hash[weekday1.to_s] > weekday_hash[weekday2]
      errors.add(:weekday2, "must be before than weekday1")
    end
  end
end
