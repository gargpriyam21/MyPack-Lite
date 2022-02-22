require "test_helper"

class InstructorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instructor = instructors(:one)
  end

  test "should get index" do
    get instructors_url
    assert_response :success
  end

  test "should get new" do
    get new_instructor_url
    assert_response :success
  end

  test "should create instructor" do
    assert_difference("Instructor.count") do
      post instructors_url, params: { instructor: { department: @instructor.department, email: @instructor.email, instructor_id: @instructor.instructor_id, name: @instructor.name, password: @instructor.password } }
    end

    assert_redirected_to instructor_url(Instructor.last)
  end

  test "should show instructor" do
    get instructor_url(@instructor)
    assert_response :success
  end

  test "should get edit" do
    get edit_instructor_url(@instructor)
    assert_response :success
  end

  test "should update instructor" do
    patch instructor_url(@instructor), params: { instructor: { department: @instructor.department, email: @instructor.email, instructor_id: @instructor.instructor_id, name: @instructor.name, password: @instructor.password } }
    assert_redirected_to instructor_url(@instructor)
  end

  test "should destroy instructor" do
    assert_difference("Instructor.count", -1) do
      delete instructor_url(@instructor)
    end

    assert_redirected_to instructors_url
  end

  test "should not create instructor with null values" do
    post instructor_url, params: { instructor: {} }
    assert_response :error
  end

  test "should not create instructor with invalid email" do
    post students_url, params: { instructor: { department: 'adjvisudb', email: 'gfdbdsa#jbdsvj', instructor_id: 2, name: 'random', password: 'random' } }
    assert_response :error
  end

  test "should not create instructor with invalid date of birth" do
    post students_url, params: { instructor: { department: 'adjvisudb', email: 'gfdbdsa#jbdsvj', instructor_id: 2, name: 'random', password: 'random' } }
    assert_response :error
  end

  test "should not create instructor with invalid phone_number" do
    post students_url, params: { instructor: { department: 'adjvisudb', email: 'gfdbdsa#jbdsvj', instructor_id: 2, name: 'random', password: 'random' } }
    assert_response :error
  end
end
