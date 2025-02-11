class UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin # ユーザーのドメインは全て管理者しかアクセスできない
  before_action :set_shop
  before_action :set_user, only: [:edit, :update]

  def new
    @user = @shop.users.build
  end

  def create
    if user_params[:password].blank? && user_params[:name].blank? && user_params[:email].present?
      # 他店舗登録の場合（上の条件の時だけ特別に他店舗登録する）
      create_multi_shop_owner
    else
      # 新規登録の場合
      create_new_owner
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

  def create_multi_shop_owner
    user = User.find_by(email: user_params[:email])

    if user.present?
      ActiveRecord::Base.transaction do
        unless @shop.users.exists?(id: user.id)
          @shop.shop_users.create!(user: user)
          flash[:success] = '既存ユーザーを店舗に追加しました'
          redirect_to shop_path(@shop)
        else
          flash[:danger] = 'このユーザーは既にこの店舗に登録されています'
          @user = @shop.users.build(user_params)
          render :new
        end
      end
    else
      flash[:danger] = 'メールアドレスに一致するユーザーが見つかりません。新規登録の場合は名前とパスワードを入力してください'
      @user = @shop.users.build(user_params)
      render :new
    end
  end

  def create_new_owner
    @user = User.new(user_params)
    ActiveRecord::Base.transaction do
      if @user.save
        @shop.shop_users.create!(user: @user)
        flash[:success] = 'ユーザーを追加しました'
        redirect_to shop_path(@shop)
      else
        flash[:danger] = 'ユーザーの追加に失敗しました'
        render :new
      end
    end
  end

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
