class ReviewsController < ApplicationController
  before_action :require_login, only: [:index]
  before_action :set_shop
  before_action :set_review, only: [:notice]

  def index
    @shop = Shop.find(params[:shop_id])
    @reviews = @shop.reviews.order(created_at: :desc)
    @paginated_reviews = @reviews.page(params[:page]).per(5)

    # 月別データを取得
    monthly_counts = @reviews
      .group_by { |review| review.created_at.beginning_of_month }
      .transform_keys { |date| date.strftime('%Y年%m月') }
      .transform_values(&:count)
      .sort.to_h

    # 累積データを計算
    cumulative_counts = monthly_counts
      .each_with_object({}) do |(date, count), acc|
        acc[date] = (acc.empty? ? count : acc.values.last + count)
      end

    @monthly_data = [
      {
        name: "累積レビュー数",
        data: cumulative_counts
      },
      {
        name: "月別レビュー数",
        data: monthly_counts
      }
    ]
  end

  def new
    @review = @shop.reviews.new
  end

  def create
    @review = @shop.reviews.new(review_params)
    if @review.save
      @comment = @review.comments
      render 'notice'
    else
      flash.now[:alert] = 'レビューの保存に失敗しました。入力内容を確認してください。'
      render :new
    end
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
