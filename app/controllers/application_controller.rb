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
      "instructor" => ['create_course', 'delete_course', 'update_course', 'edit_course', 'show_course', 'show_instructor_course', 'create_enrollment', 'delete_enrollment', 'edit_enrollment', 'update_enrollment', 'show_enrollment', 'show_instructor', 'show_student', 'showinstructorcourses', 'show_instructor_student', 'view_course', 'show_all_student', 'show_instructor_students_enrolled', 'unenroll_course','create_waitlist','delete_waitlist','update_waitlist','view_waitlist','show_waitlist','edit_waitlist','remove_waitlist'],
      "admin" => ['create_course', 'create_enrollment', 'create_instructor', 'create_student', 'create_waitlist', 'delete_admin', 'delete_course', 'delete_enrollment', 'delete_instructor', 'delete_student', 'delete_waitlist', 'drop_course', 'edit_admin', 'edit_course', 'edit_enrollment', 'edit_instructor', 'edit_student', 'edit_waitlist', 'enroll_course', 'show_admin', 'show_all_student', 'show_course', 'show_enrollment', 'show_instructor', 'show_instructor_students_enrolled', 'show_student', 'show_waitlist', 'update_admin', 'update_course', 'update_enrollment', 'update_instructor', 'update_student', 'update_waitlist', 'view_admin', 'view_course', 'view_enrollment', 'view_instructor', 'view_student', 'view_waitlist'],
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
