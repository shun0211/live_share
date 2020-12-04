require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user){ FactoryBot.build(:user) }
  let(:ticket){ FactoryBot.build(:ticket) }
  it "一枚の投稿チケットに一人のユーザしかいいねレコードが作成できないこと" do
    like = Like.create(user: user, ticket: ticket)
    duplicate_like = Like.new(user: user, ticket: ticket)
    expect(duplicate_like).to_not be_valid
  end
end
