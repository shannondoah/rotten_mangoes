class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def admin_only
    if !current_user.admin || !current_user
      flash[:alert] = "You must be an administrator to view this page."
      redirect_to new_session_path
    end
  end

  def mimicing?
    actual_user.present?
  end

  def actual_user
    @actual_user ||= User.where(admin: true).find_by(id: session[:admin_id]) if session[:admin_id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user, :admin, :actual_user, :mimicing?
end
