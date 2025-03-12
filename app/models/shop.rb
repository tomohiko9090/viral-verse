class Shop < ApplicationRecord
  has_many :shop_users, dependent: :destroy
  has_many :users, through: :shop_users
  has_many :reviews, dependent: :destroy

  scope :with_latest_reviews, -> {
    left_outer_joins(:reviews)
    .select('shops.*, MAX(reviews.created_at) as latest_review_date')
    .group('shops.id')
  }

  validates :name, presence: true

  after_create :generate_qr_codes
  after_update :generate_qr_codes

  private

  def generate_qr_codes
    # URLが変更された場合、もしくはQRコードがnilの場合のみ実行
    return unless saved_change_to_url? || qr_code_ja.nil? || qr_code_en.nil?

    # 日本語版QRコード生成
    generate_qr_code(:ja)
    # 英語版QRコード生成
    generate_qr_code(:en)
  rescue => e
    Rails.logger.error "Failed to generate QR codes for Shop #{id}: #{e.message}"
  end

  def generate_qr_code(locale)
    host = Rails.env.production? ? 'https://***REMOVED***' : 'http://127.0.0.1:3000'
    review_url = Rails.application.routes.url_helpers.localized_new_shop_reviews_url(self, locale: locale, host: host)
    qr = RQRCode::QRCode.new(review_url)
    png = qr.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )

    file_name = "shop_review_qr_#{id}_#{locale}.png"
    file_path = Rails.root.join('public', 'qr_codes', file_name)

    File.open(file_path, 'wb') { |f| f.write(png.to_s) }

    # ロケールに応じてカラムを更新
    column_name = "qr_code_#{locale}"
    update_column(column_name, "/qr_codes/#{file_name}")
  end
end