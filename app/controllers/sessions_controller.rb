class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if user.admin?
        # システム管理者の場合
        flash[:success] = 'ログインしました'
        redirect_to root_path        
      elsif user.owner?
        shops_count = user.shops.count
        if shops_count == 0
          flash[:alert] = '店舗が紐づいていません'
          redirect_to root_path
        elsif shops_count == 1
          # 1店舗のみの場合はその店舗の詳細へ
          flash[:success] = 'ログインしました'
          redirect_to shop_path(user.shops.first)
        else
          # 複数店舗ある場合は一覧へ
          flash[:success] = 'ログインしました'
          redirect_to shops_path
        end
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