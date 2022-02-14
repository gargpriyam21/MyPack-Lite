class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  helper_method :check_permissions?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  #Give appropriate permissions to the appropriate element
  def check_permissions?(user_role, action)

    # All Permissions
    # create_admin, show_admin, edit_admin, delete_admin, update_admin, view_admin
    # create_course, show_course, edit_course, delete_course, update_course, enroll_course, drop_course, view_course
    # create_enrollment, show_enrollment, edit_enrollment, delete_enrollment, update_enrollment, view_enrollment
    # create_instructor, show_instructor, edit_instructor, delete_instructor, update_instructor, view_instructor
    # create_student, show_student, edit_student, delete_student, update_student, view_student
    # create_waitlist, show_waitlist, edit_waitlist, delete_waitlist, update_waitlist, view_waitlist
    # show_all_student, show_instructor_students_enrolled

    @actions = {
      "instructor" => ['create_course', 'delete_course', 'update_course', 'edit_course', 'show_course', 'show_instructor_course', 'create_enrollment', 'delete_enrollment', 'edit_enrollment', 'update_enrollment', 'show_enrollment', 'show_instructor', 'show_student', 'showinstructorcourses', 'show_instructor_student', 'view_course', 'show_all_student', 'show_instructor_students_enrolled', 'unenroll_course'],
      "admin" => ['create_course', 'delete_course', 'update_course', 'edit_course', 'show_course', 'show_instructor_course', 'create_enrollment', 'delete_enrollment', 'edit_enrollment', 'update_enrollment', 'show_enrollment', 'show_instructor', 'show_instructor_student',
                  'edit_student', 'create_student', 'delete_student', 'update_student', 'create_instructor', 'delete_instructor', 'update_instructor', 'edit_instructor', 'showinstructorcourses', 'show_all_student'],
      "student" => ['show_course', 'view_course', 'enroll_course', 'drop_course', 'show_enrolled_course']
    }
    if @actions[user_role] && @actions[user_role].include?(action)
      return true
    end
    return false
  end

  def authorized
    if current_user.nil?
      redirect_to root_path
    end
  end
end
