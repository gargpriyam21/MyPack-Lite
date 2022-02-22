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
    # view_admin
    # show_admin
    # create_admin
    # edit_admin
    # show_all_enrollments
    # update_admin
    # delete_admin
    #
    # view_course
    # show_course
    # create_course
    # edit_course
    # enroll_course
    # show_instructor_student
    # show_all_student
    # show_enrolled_course
    # show_waitlist_course
    # drop_course
    # remove_waitlist
    # update_course
    # delete_course
    #
    # view_enrollment
    # show_enrollment
    # create_enrollment
    # edit_enrollment
    # show_instructor_students_enrolled
    # update_enrollment
    # unenroll_course
    # delete_enrollment
    #
    # view_instructor
    # show_instructor
    # create_instructor
    # edit_instructor
    # update_instructor
    # show_instructor_students
    # delete_instructor
    #
    # view_student
    # show_student
    # create_student
    # edit_student
    # update_student
    # delete_student
    #
    # view_waitlist
    # show_waitlist
    # create_waitlist
    # edit_waitlist
    # show_instructor_students_waitlisted
    # delete_waitlist

    # @actions = {
    #   "instructor" => ['show_instructor_students_waitlisted', 'show_instructor_students', 'create_course', 'delete_course', 'update_course', 'edit_course', 'show_course', 'show_instructor_course', 'create_enrollment', 'delete_enrollment', 'edit_enrollment', 'update_enrollment', 'show_enrollment', 'show_instructor', 'show_student', 'showinstructorcourses', 'show_instructor_student', 'view_course', 'show_all_student', 'show_instructor_students_enrolled', 'unenroll_course', 'create_waitlist', 'delete_waitlist', 'update_waitlist', 'view_waitlist', 'show_waitlist', 'edit_waitlist', 'remove_waitlist'],
    #   "admin" => ['show_instructor_students_waitlisted', 'show_all_enrollments', 'create_course', 'create_enrollment', 'create_instructor', 'create_student', 'create_waitlist', 'delete_admin', 'delete_course', 'delete_enrollment', 'delete_instructor', 'delete_student', 'delete_waitlist', 'drop_course', 'edit_admin', 'edit_course', 'edit_enrollment', 'edit_instructor', 'edit_student', 'edit_waitlist', 'enroll_course', 'show_admin', 'show_all_student', 'show_course', 'show_enrollment', 'show_instructor', 'show_instructor_students_enrolled', 'show_student', 'show_waitlist', 'update_admin', 'update_course', 'update_enrollment', 'update_instructor', 'update_student', 'update_waitlist', 'view_admin', 'view_course', 'view_enrollment', 'view_instructor', 'view_student', 'view_waitlist'],
    #   "student" => ['show_course', 'view_course', 'enroll_course', 'drop_course', 'show_enrolled_course', 'show_waitlist_course', 'remove_waitlist']
    # }

    @actions = {
      'admin' => ['view_admin',
                  'show_admin',
                  'edit_admin',
                  'update_admin',
                  'view_course',
                  'show_course',
                  'create_course',
                  'edit_course',
                  'enroll_course',
                  'show_instructor_student',
                  'show_all_student',
                  'show_enrolled_course',
                  'show_waitlist_course',
                  'drop_course',
                  'remove_waitlist',
                  'update_course',
                  'delete_course',
                  'view_enrollment',
                  'show_enrollment',
                  'create_enrollment',
                  'edit_enrollment',
                  'show_instructor_students_enrolled',
                  'update_enrollment',
                  'unenroll_course',
                  'delete_enrollment',
                  'view_instructor',
                  'show_instructor',
                  'create_instructor',
                  'edit_instructor',
                  'update_instructor',
                  'show_instructor_students',
                  'delete_instructor',
                  'view_student',
                  'show_student',
                  'create_student',
                  'edit_student',
                  'update_student',
                  'delete_student',
                  'view_waitlist',
                  'show_waitlist',
                  'create_waitlist',
                  'edit_waitlist',
                  'show_instructor_students_waitlisted',
                  'delete_waitlist',
                  'show_all_enrollments'],
      'instructor' => ['view_course',
                       'show_course',
                       'create_course',
                       'edit_course',
                       'enroll_course',
                       'show_instructor_student',
                       'show_all_student',
                       'show_enrolled_course',
                       'show_waitlist_course',
                       'drop_course',
                       'remove_waitlist',
                       'update_course',
                       'delete_course',
                       'view_enrollment',
                       'show_enrollment',
                       'create_enrollment',
                       'show_instructor_students_enrolled',
                       'update_enrollment',
                       'unenroll_course',
                       'delete_enrollment',
                       'view_instructor',
                       'show_instructor',
                       'edit_instructor',
                       'update_instructor',
                       'show_instructor_students',
                       'view_student',
                       'show_student',
                       'view_waitlist',
                       'show_waitlist',
                       'create_waitlist',
                       'show_instructor_students_waitlisted',
                       'delete_waitlist'],
      'student' => ['view_course',
                    'show_course',
                    'enroll_course',
                    'show_enrolled_course',
                    'show_waitlist_course',
                    'drop_course',
                    'remove_waitlist']
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
