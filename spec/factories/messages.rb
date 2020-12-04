FactoryBot.define do
  factory :message do
    content { "よろしくお願いします。" }
    association :user
    association :room
  end
end
