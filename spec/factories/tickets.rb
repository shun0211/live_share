# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    sheet_type { '立ち見' }
    price { 5000 }
    shipping { 1 }
    delivery_method { '名古屋駅手渡し' }
    number_of_sheets { 2 }
    description { "複数チケットが当たったので、出品します。\nできればフォーリミのファンの方に譲りたいと思っています。\nよろしくお願いします！" }
    thumbnail { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'thumbnail.jpeg')) }
    event_name { 'YON FES 2021' }
    venue { 'モリコロパーク' }
    event_date { '2021-04-03' }
    association :seller
    association :buyer
  end
end
