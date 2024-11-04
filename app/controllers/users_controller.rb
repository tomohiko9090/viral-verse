class UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin # ユーザーのドメインは全て管理者しかアクセスできない
  before_action :set_shop
  before_action :set_user, only: [:edit, :update]

  def new
    @user = @shop.users.build
  end

  def create
    @user = @shop.users.build(user_params)

    if @user.save
      flash[:success] = 'ユーザーを追加しました'
      redirect_to shop_path(@shop)
    else
      flash[:danger] = 'ユーザーの追加に失敗しました'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました'
      redirect_to shop_path(@shop)
    else
      flash[:danger] = 'ユーザー情報の更新に失敗しました'
      render :edit
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_user
    @user = @shop.users.find(params[:id])
  end

  def user_params
    # 注意: オーナー権限しか作成させない
    params.require(:user).permit(:name, :email, :password, :language_id).merge(role: 'owner')
  end
end
