class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.owner?
        flash[:success] = 'ログインしました'
        redirect_to shop_path(user.shop_id)
      else
        flash[:success] = 'ログインしました'
        redirect_to root_path
      end
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが無効です'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end
end
