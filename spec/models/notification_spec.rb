require 'rails_helper'

RSpec.describe Notification, type: :model do
  it "ユーザモデルからお知らせが保存されること" do
    user = FactoryBot.build(:user)
    user.save!
    user.active_notifications.create!(action: "like", visited_id: user, ticket_id: ticket)
    user.reload
    expect(user.active_notifications.count).to eq 1
  end
end
