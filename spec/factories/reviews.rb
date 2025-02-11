FactoryBot.define do
  factory :review do
    association :shop
    score { rand(1..5) }
    comments { "とても良い店舗でした。" }

    trait :low_score do
      score { rand(1..3) }
      feedback1 { "改善点1" }
      feedback2 { "改善点2" }
    end
  end
end
