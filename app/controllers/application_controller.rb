class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?, :is_administrator?
  before_action :check_user_status, if: :current_user
  
  # Current session user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
  # Check user is banned or suspended
  def check_user_status
    if current_user.suspended?
      reset_session
      redirect_to login_path, alert: "Your account is suspended. Access denied."
    elsif current_user.banned?
      reset_session
      redirect_to login_path, alert: "Your account has been banned.Access denied."
    end
  end
  # Check user is logged in
  def logged_in?
    !current_user.nil?
  end
  # Administrative access pages are allowing
  def is_administrator?
    session[:is_admin] == true
  end
  # Pages that require sign in
  def require_login
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access that feature."
    end
  end

    private
      
end
