class ApplicationController < ActionController::Base
  before_action :set_default_locale

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
      redirect_to login_path
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end

  def authorized_for_shop?(shop)
    return true if current_user&.admin?

    ShopUser.exists?(shop: shop, user: current_user)
  end

  def redirect_shop_index
    flash[:danger] = 'アクセス権限がありません'
    redirect_to shops_path
  end

  def set_default_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end