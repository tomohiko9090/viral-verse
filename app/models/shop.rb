class Shop < ApplicationRecord
  has_many :users
  has_many :reviews, dependent: :destroy

  scope :with_latest_reviews, -> {
    left_outer_joins(:reviews)
    .select('shops.*, MAX(reviews.created_at) as latest_review_date')
    .group('shops.id')
    .order(latest_review_date: :desc)
  }

  validates :name, presence: true
  validates :url, presence: true

  after_create :generate_qr_code
  after_update :generate_qr_code

  def generate_qr_code
    # urlが変更された場合、もしくはqr_codeがnilの場合のみ実行
    return unless saved_change_to_url? || qr_code.nil?

    host = Rails.env.production? ? 'kuchikomi.elevator' : 'http://127.0.0.1:3000'
    review_url = Rails.application.routes.url_helpers.new_shop_review_url(self, host: host)
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

    file_name = "shop_review_qr_#{id}.png"
    file_path = Rails.root.join('public', 'qr_codes', file_name)

    File.open(file_path, 'wb') { |f| f.write(png.to_s) }

    update_column(:qr_code, "/qr_codes/#{file_name}")
  rescue => e
    Rails.logger.error "Failed to generate QR code for Shop #{id}: #{e.message}"
  end
end
