require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message){ FactoryBot.build(:message) }
  it "メッセージがなければ無効な状態であること" do
    message.content = nil
    message.valid?
    expect(message).to_not be_valid
  end
  it "メッセージが空白の場合、無効な状態であること" do
    message.content = " "
    message.valid?
    expect(message).to_not be_valid
  end
end
