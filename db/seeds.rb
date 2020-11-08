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
    description: "仕事で行けなくなりました。無念です。\nどなたか代わりに楽しんでください。\nチケットは最初に購入希望してくださった方にお譲りします。"
  )
end

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
