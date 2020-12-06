FactoryBot.define do
  factory :message do
    content { "よろしくお願いします。" }
    association :user
    association :room
  end

  factory :messages do
    sequence(:content) { |n| "Hello, World!! #{n}個目" }
    association :user
    association :room
  end
end
