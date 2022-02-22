require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end

  test "should not create course with null values" do
    post courses_url, params: { course: {} }
    assert_response :error
  end

  test "should not create course with negative capacity" do
    post courses_url, params: { course: { capacity: -10, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with null name only" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with null description only" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with null course code only" do
    post courses_url, params: { course: { capacity: @course.capacity, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with null room only" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with invalid course_code" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: "CSDSC63682", description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with weekday1 equal to weekday2" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: "MON", weekday2: "MON" } }
    assert_response :error
  end

  test "should not create course with end_time less than start_time only" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: "12:54", instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: "15:43", status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: @course.waitlist_capacity, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

  test "should not create course with negative waitlist_capacity only" do
    post courses_url, params: { course: { capacity: @course.capacity, course_code: @course.course_code, description: @course.description, end_time: @course.end_time, instructor_name: @course.instructor_name, name: @course.name, room: @course.room, start_time: @course.start_time, status: @course.status, students_enrolled: @course.students_enrolled, students_waitlisted: @course.students_waitlisted, waitlist_capacity: -120, weekday1: @course.weekday1, weekday2: @course.weekday2 } }
    assert_response :error
  end

end
