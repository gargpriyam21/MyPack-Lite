require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      # post students_url, params: { student: { date_of_birth: @student.date_of_birth, email: @student.email, major: @student.major, name: @student.name, password: @student.password, phone_number: @student.phone_number, student_id: @student.student_id } }
      post students_url, params: { student: { date_of_birth: "45/54/3234", email: "random#ran", major: "RNDM", name: "something", password: "random", phone_number: "12453", student_id: 5 } }
    end

    # assert_redirected_to student_url(Student.last)
    assert_redirected_to login_path
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { date_of_birth: @student.date_of_birth, email: @student.email, major: @student.major, name: @student.name, password: @student.password, phone_number: @student.phone_number, student_id: @student.student_id } }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end
end
