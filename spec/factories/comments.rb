# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { '値下げお願いできないでしょうか' }
    association :user
    association :ticket
  end
end
