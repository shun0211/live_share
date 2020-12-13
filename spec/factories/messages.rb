# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    sequence(:content, 1) { |n| "Hello, World!! #{n}個目" }
    association :user
    association :room
  end
end
