class ReviewsController < ApplicationController
  before_action :set_shop
  before_action :set_review, only: [:notice]

  def index
    @reviews = @shop.reviews
  end

  def new
    @review = @shop.reviews.new
  end

  def create
    @review = @shop.reviews.new(review_params)
    if @review.save
      redirect_to notice_shop_review_path(@shop, @review)
    else
      flash.now[:alert] = 'レビューの保存に失敗しました。入力内容を確認してください。'
      render :new
    end
  end

  def notice
    @review = @shop.reviews.find(params[:id])
  end


  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_review
    @review = @shop.reviews.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to shop_reviews_path(@shop), alert: 'レビューが見つかりません。'
  end

  def review_params
    params.require(:review).permit(:score, :comments)
  end
end
