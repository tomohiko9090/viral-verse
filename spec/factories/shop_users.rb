FactoryBot.define do
  factory :shop_user do
    association :shop
    association :user
  end
end
