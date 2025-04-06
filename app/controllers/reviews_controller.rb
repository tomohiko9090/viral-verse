class ReviewsController < ApplicationController
  before_action :set_locale
  before_action :require_login, only: [:index]
  before_action :set_shop
  before_action :set_review, only: [:notice, :survey1, :survey2, :submit_survey1, :submit_survey2]

  def index
    redirect_shop_index unless authorized_for_shop?(@shop)

    @shop = Shop.find(params[:shop_id])
    @reviews = @shop.reviews.order(created_at: :desc)

    # ログインユーザーのレビューを除外した統計情報用のレビュー
    @public_reviews = @reviews.where(user_id: nil)

    # 検索条件の有無を確認
    @is_searching = params[:score].present? || params[:month].present?

    # 検索条件の適用
    @reviews = @reviews.where(score: params[:score]) if params[:score].present?

    if params[:month].present?
      selected_date = Date.parse(params[:month])
      @reviews = @reviews.where(
        created_at: selected_date.beginning_of_month..selected_date.end_of_month
      )
    end

    # 検索時は10件、通常時は5件表示
    per_page = @is_searching ? 10 : 5
    @paginated_reviews = @reviews.page(params[:page]).per(per_page)

    # 検索していない場合のみグラフデータを準備
    unless @is_searching
      # 月別データの取得（ログインユーザーのレビューを除外）
      monthly_counts = @public_reviews
        .group_by { |review| review.created_at.beginning_of_month }
        .transform_keys { |date| date.strftime('%Y年%m月') }
        .transform_values(&:count)
        .sort.to_h

      # 累積データの計算
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

    # 検索用の月の選択肢を準備
    @available_months = @shop.reviews
      .select("DISTINCT DATE_FORMAT(created_at, '%Y-%m-01') as month_date")
      .order('month_date DESC')
      .map { |r| Date.parse(r.month_date) }
  end

  def new
    @review = @shop.reviews.new
  end

  def create
    @review = @shop.reviews.new(review_params)

    # ログインしているユーザーがいればuser_idを設定
    @review.user_id = current_user&.id if defined?(current_user)

    if @review.save
      @comment = @review.comments
      if @review.score.between?(1, 3)
        # 評価が1-3の場合はアンケートへ
        redirect_to localized_survey1_shop_review_path(@shop, @review, locale: params[:locale])
      else
        # 評価が4-5の場合は通常の完了画面へ
        redirect_to localized_notice_shop_review_path(@shop, @review, locale: params[:locale])
      end
    else
      flash.now[:alert] = t('.save_error')
      render :new
    end
  end

  def survey1
    render :survey1
  end

  def survey2
    # 前のページ（survey1）からの遷移でない場合はsurvey1にリダイレクト
    if session[:feedback1].blank?
      redirect_to survey1_shop_review_path(@shop, @review)
    else
      render :survey2
    end
  end

  def submit_survey1
    session[:feedback1] = params[:feedback1]
    redirect_to localized_survey2_shop_review_path(@shop, @review, locale: params[:locale])
  end

  def submit_survey2
    # survey1とsurvey2の回答を同時に保存
    if @review.update(
      feedback1: session[:feedback1],
      feedback2: params[:review][:feedback2]
    )
      # セッションをクリア
      session.delete(:feedback1)
      redirect_to localized_notice_shop_review_path(@shop, @review, locale: params[:locale])
    else
      flash.now[:alert] = t('.survey_save_error')
      render :survey2
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

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end
end
