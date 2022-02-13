class ApplicationController < ActionController::Base
  # before_action :authorized
  helper_method :current_user
  helper_method :check_permissions?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def check_permissions?(user_type, action)
    @actions = {"instructor" => ['create_course', 'delete_course',  'update_course', 'edit_course','show_course','show_instructor_course', 'create_enrollment','delete_enrollment','edit_enrollment','update_enrollment','show_enrollment','show_instructor','show_student','showinstructorcourses','show_instructor_student'],
                "admin" => ['create_course', 'delete_course',  'update_course', 'edit_course','show_course','show_instructor_course', 'create_enrollment','delete_enrollment','edit_enrollment','update_enrollment','show_enrollment','show_instructor','show_instructor_student',
                            'edit_student','create_student','delete_student','update_student','create_instructor','delete_instructor','update_instructor','edit_instructor','showinstructorcourses'],
                "student" => ['show_course', 'create_enrollment', 'edit_enrollment','update_enrollment','show_enrollment']
    }
    if @actions[user_type] && @actions[user_type].include?(action)
      return true
    end
    return false
  end

  # def authorized
  #   if current_user.nil?
  #     redirect_to root_path
  #   end
  # end
end
