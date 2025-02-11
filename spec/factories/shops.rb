FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "テスト店舗#{n}" }
    sequence(:url) { |n| "test-shop-#{n}" }
    qr_code { "path/to/qr_code.png" }
  end
end
