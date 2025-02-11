FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "テストユーザー#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { 2 }
    language_id { 1 }

    trait :admin do
      role { 1 }
    end

    trait :owner do
      role { 2 }
    end

    trait :multiple_owner do
      role { 3 }
    end
  end
end
