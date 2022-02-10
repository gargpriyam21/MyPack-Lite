class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def authorized
    if current_user.nil?
      redirect_to root_path
    end
    # unless current_user.nil?
  end
end