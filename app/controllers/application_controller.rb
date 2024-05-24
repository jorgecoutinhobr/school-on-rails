class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  before_action :require_authentication

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def require_authentication
    return if user_signed_in?

    flash[:alert] = 'You must be signed in to access this section'
    redirect_to new_session_path
  end
end
