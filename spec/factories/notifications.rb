FactoryBot.define do
  factory :notification do
    action { "like" }
    association :visitor
    association :visited
    association :ticket
  end
end
