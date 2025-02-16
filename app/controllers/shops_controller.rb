class ShopsController < ApplicationController
  before_action :require_login # ログインしないと店舗のドメインには全てアクセスさせない
  before_action :require_admin, only: [:new, :create, :update, :destroy] # 更新系できるのは管理者だけ
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @shops = Shop.with_latest_reviews
    else
      @shops = current_user.shops.with_latest_reviews
    end
  end

  def show
    redirect_shop_index unless authorized_for_shop?(@shop)

    @users = @shop.users.includes(:language)
    @new_user = User.new
  end

  def new
    @shop = Shop.new
  end

  def edit
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      flash[:success] = "「#{@shop.name}」が登録されました"
      redirect_to shops_path
    else
      flash[:danger] = '新規店舗の登録に失敗しました'
      render :new
    end
  end

  def update
    if @shop.update(shop_params)
      flash[:success] = '更新しました'
      redirect_to @shop
    else
      flash[:danger] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @shop.destroy
    flash[:success] = '店舗を削除しました'
    redirect_to shops_url
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :url)
  end
end
