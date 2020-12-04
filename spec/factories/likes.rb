FactoryBot.define do
  factory :like do
    association :user
    association :ticket
  end
end
