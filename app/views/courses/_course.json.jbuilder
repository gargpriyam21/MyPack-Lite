json.extract! course, :id, :name, :description, :instructor_name, :weekdays, :start_time, :end_time, :course_code, :capacity, :students_enrolled, :waitlist_capacity, :students_waitlisted, :status, :room, :created_at, :updated_at
json.url course_url(course, format: :json)
