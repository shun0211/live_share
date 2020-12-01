FactoryBot.define do
  factory :user do
    # idはデータベースに任せる。決め打ちNG
    nickname { "sakai" }
    sequence(:email) { |n| "aaa#{n}@example.com" }
    password { "password1" }
    password_confirmation { "password1" }
  end
end
