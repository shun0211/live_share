User.create!(
  nickname: "さかい",
  email: "aaa@example.com",
  password: "password1",
  profile: "たまにチケットを出品してます。
  sumikaが大好きです。
  何卒、よろしくお願いします＼(^o^)／"
)

User.create!(
  nickname: "木内",
  email: "bbb@example.com",
  password: "password1",
  profile: "行けなくなったチケットを出品しようと思っています。
  miwaをよく聴きます。
  よろしくお願いします😄"
)

User.create!(
  nickname: "たろう",
  email: "ccc@example.com",
  password: "password1",
  profile: "RADWIMPSが大好きです。
  毎日聴いています。
  RAD好きの方いらっしゃったらフォローお願いします！
  https://twitter.com/taro1234"
)

Ticket.create!(
  thumbnail: File.open("#{Rails.root}/app/assets/images/thumbnails.jpeg"),
  event_name: "RADWIMPS ファン感謝祭",
  event_date: "2021-05-31",
  venue: "三重県営サンアリーナ",
  shipping: rand(3) + 1,
  delivery_method: "チケット郵送",
  number_of_sheets: rand(4) + 1,
  price: (rand(10)+1) * 1000,
  description: "複数チケットが当たったので、出品します。\nできればいつもRADを応援しているファンに譲りたいです。\nよろしくお願いします！！",
  seller_id: 3
)

Ticket.create!(
  thumbnail: File.open("#{Rails.root}/app/assets/images/thumbnails.jpeg"),
  event_name: "miwa ドームツアー2021",
  event_date: "2021-06-03",
  venue: "ナゴヤドーム",
  shipping: rand(3) + 1,
  delivery_method: "現地で手渡し",
  number_of_sheets: rand(4) + 1,
  price: (rand(10)+1) * 1000,
  description: "友人が行けなくなったため、一緒に参戦してくれる方を募集します。\nmiwa好きの方だとうれしいです😊\nよろしくお願いします！",
  seller_id: 2
)


100.times do |n|
  Ticket.create!(
    thumbnail: File.open("#{Rails.root}/app/assets/images/thumbnails.jpeg"),
    event_name: "YONFES 2021",
    event_date: "2021-04-03",
    venue: "愛知県長久手市茨ケ廻間乙1533-1 モリコロパーク",
    shipping: rand(3) + 1,
    delivery_method: "名古屋駅手渡し",
    number_of_sheets: rand(4) + 1,
    price: (rand(10)+1) * 1000,
    description: "仕事で行けなくなりました。無念です。\nどなたか代わりに楽しんでください。\nチケットは最初に購入希望してくださった方にお譲りします。",
    seller_id: 1
  )
end

Room.create!
Entry.create!(
  user_id: 1,
  room_id: 1
)
Entry.create!(
  user_id: 2,
  room_id: 1
)
100.times do |n|
  Message.create!(
    user_id: 2,
    room_id: 1,
    content: "Hello, World"
  )
end
