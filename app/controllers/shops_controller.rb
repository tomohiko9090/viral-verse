class ShopsController < ApplicationController
  before_action :require_login # ログインしないとすべてアクセスできない
  before_action :require_admin, only: [:index, :new, :create, :destroy] # 一覧、新規作成、削除ができるのは管理者だけ
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  def index
    @shops = Shop.all
  end

  def show
  end

  def new
    @shop = Shop.new
  end

  def edit
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to @shop, notice: 'Shop was successfully created. QR code has been generated.'
    else
      render :new
    end
  end

  def update
    if @shop.update(shop_params)
      redirect_to @shop, notice: 'Shop was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to shops_url, notice: 'Shop was successfully destroyed.'
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :url)
  end
end
