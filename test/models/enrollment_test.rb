require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not create application with null values" do
    @enrollment = Enrollment.new
    assert_not @enrollment.save
  end
end


