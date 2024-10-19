class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  helper_method :current_user, :logged_in?

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください"
      redirect_to login_path
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "権限がありません"
      redirect_to root_path
    end
  end

  def require_owner
    unless current_user&.owner?
      flash[:alert] = "権限がありません"
      redirect_to root_path
    end
  end
end
