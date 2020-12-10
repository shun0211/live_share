# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  it 'ユーザモデルからお知らせが保存されること' do
    user = FactoryBot.create(:user)
    user.active_notifications.create(action: 'like', visitor: user)
    expect(user.active_notifications.size).to eq 1
  end

  it 'visitorで通知を送信したユーザを取得できること' do
    user = FactoryBot.create(:user, nickname: 'visitor')
    notification = FactoryBot.create(:notification, visitor: user)
    expect(notification.visitor.nickname).to eq 'visitor'
  end

  it 'visitedで通知を受信したユーザを取得できること' do
    user = FactoryBot.create(:user, nickname: 'visited')
    notification = FactoryBot.create(:notification, visited: user)
    expect(notification.visited.nickname).to eq 'visited'
  end
end
