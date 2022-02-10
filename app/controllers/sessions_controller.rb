class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      if user.user_role == "student"
        user_class = Student
      elsif user.user_role == "instructor"
        user_class = Instructor
      elsif user.user_role == "admin"
        user_class = Admin
      else
        user_class = nil
      end
      specific_user_object = user_class.find_by_user_id(user.id)
      if specific_user_object.authenticate(params[:password])
        session[:user_id] = user.id
        session[:user_role] = user.user_role
        redirect_to root_url
      else
        flash[:alert] = "Email or password is invalid"
        redirect_to login_path
      end
    else
      flash[:alert] = "No user found"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end

