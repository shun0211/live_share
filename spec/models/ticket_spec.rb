# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'モデルのバリデーション' do
    # letは遅延評価されるという特徴を持ち、呼ばれるまで呼び出されない
    let(:ticket) { FactoryBot.build(:ticket) }
    let(:user) { FactoryBot.build(:user) }

    it 'thumbnail, event_name, event_date, venue, number_of_sheets, shipping, delivery_method, priceがあれば有効な状態であること' do
      a_ticket = described_class.new(thumbnail: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/thumbnail.jpeg')),
                                     event_name: 'YON FES 2021',
                                     event_date: '2021-04-03',
                                     venue: 'モリコロパーク',
                                     number_of_sheets: 2,
                                     shipping: 1,
                                     delivery_method: '名古屋駅手渡し',
                                     price: 5000,
                                     seller: user)
      expect(a_ticket).to be_valid
    end

    it 'thumbnailがなければ無効な状態であること' do
      ticket.thumbnail = nil
      expect(ticket).not_to be_valid
    end

    it 'event_nameがなければ無効な状態であること' do
      ticket.event_name = nil
      expect(ticket).not_to be_valid
    end

    context 'event_nameが30文字の場合' do
      it '有効であること' do
        ticket.event_name = 'a' * 30
        expect(ticket).to be_valid
      end
    end

    context 'event_nameが31文字の場合' do
      it '無効であること' do
        ticket.event_name = 'a' * 31
        expect(ticket).not_to be_valid
      end
    end

    it 'event_dateがなければ無効な状態であること' do
      ticket.event_date = nil
      expect(ticket).not_to be_valid
    end

    it 'venueがなければ無効な状態であること' do
      ticket.venue = nil
      expect(ticket).not_to be_valid
    end

    context 'venueが30文字の場合' do
      it '有効であること' do
        ticket.venue = 'a' * 30
        expect(ticket).to be_valid
      end
    end

    context 'venueが31文字の場合' do
      it '無効であること' do
        ticket.venue = 'a' * 31
        expect(ticket).not_to be_valid
      end
    end

    it 'number_of_sheetsがなければ無効な状態であること' do
      ticket.number_of_sheets = nil
      expect(ticket).not_to be_valid
    end

    it 'shippingがなければ無効な状態であること' do
      ticket.shipping = nil
      expect(ticket).not_to be_valid
    end

    it 'delivery_methodがなければ無効な状態であること' do
      ticket.delivery_method = nil
      expect(ticket).not_to be_valid
    end

    context 'delivery_methodが30文字の場合' do
      it '有効であること' do
        ticket.delivery_method = 'a' * 30
        expect(ticket).to be_valid
      end
    end

    context 'delivery_methodが31文字の場合' do
      it '無効であること' do
        ticket.delivery_method = 'a' * 31
        expect(ticket).not_to be_valid
      end
    end

    it 'priceがなければ無効な状態であること' do
      ticket.price = nil
      expect(ticket).not_to be_valid
    end

    context 'priceが301の場合' do
      it '有効であること' do
        ticket.price = 301
        expect(ticket).to be_valid
      end
    end

    context 'priceが300の場合' do
      it '無効であること' do
        ticket.price = 300
        expect(ticket).not_to be_valid
      end
    end

    context 'priceが99998の場合' do
      it '有効であること' do
        ticket.price = 99_998
        expect(ticket).to be_valid
      end
    end

    context 'priceが99999の場合' do
      it '無効であること' do
        ticket.price = 99_999
        expect(ticket).not_to be_valid
      end
    end

    context 'priceが数字以外の場合' do
      it '無効であること' do
        ticket.price = 'aaa'
        expect(ticket).not_to be_valid
      end
    end
  end

  describe '#liked_by' do
    before do
      @ticket = FactoryBot.build(:ticket)
      @user = FactoryBot.build(:user)
    end

    context 'ユーザがチケットにいいね済みの場合' do
      it 'trueを返すこと' do
        like = FactoryBot.build(:like, ticket: @ticket, user: @user)
        like.save!
        expect(@ticket.liked_by(@user)).to eq true
      end
    end

    context 'ユーザがチケットにいいねしてない場合' do
      it 'falseを返すこと' do
        like = FactoryBot.build(:like, ticket: @ticket)
        like.save!
        expect(@ticket.liked_by(@user)).to eq false
      end
    end
  end

  describe '#create_notification_like' do
    before do
      @ticket = FactoryBot.create(:ticket)
      @current_user = FactoryBot.create(:user)
      @visited = FactoryBot.create(:user)
    end

    context 'ユーザが既に通知を受けていた場合' do
      it 'レコードが保存されないこと' do
        Notification.create(visitor: @current_user, visited: @visited, ticket: @ticket, action: 'like')
        @ticket.create_notification_like(@current_user)
        expect(@current_user.passive_notifications.count).to eq 0
      end
    end

    context 'ユーザが通知を受けておらず、かつ送信者と受信者が同じユーザでない場合' do
      it 'レコードが保存されること' do
        @ticket.create_notification_like(@current_user)
        expect(@current_user.active_notifications.count).to eq 1
      end
    end

    context 'ユーザが通知を受けておらずかつ通知受信者と送信者が同じ場合' do
      it 'レコードが保存されないこと' do
        @ticket.seller_id = @current_user.id
        @ticket.create_notification_like(@current_user)
        expect(@current_user.active_notifications.count).to eq 0
      end
    end
  end

  describe '#create_notification_comment' do
    before do
      @ticket = FactoryBot.create(:ticket)
      @current_user = FactoryBot.create(:user)
      @comment = FactoryBot.create(:comment)
    end

    context 'コメント送信者がチケット出品者でないとき' do
      it 'お知らせレコードが保存されること' do
        @ticket.create_notification_comment(@current_user, @comment.id)
        expect(@current_user.active_notifications.count).to eq 1
      end
    end

    context 'コメント送信者がチケット出品者であるとき' do
      it 'お知らせレコードが保存されないこと' do
        @ticket.seller_id = @current_user.id
        @ticket.create_notification_comment(@current_user, @comment.id)
        expect(@current_user.active_notifications.count).to eq 0
      end
    end
  end

  describe '#create_notification_request' do
    before do
      @ticket = FactoryBot.create(:ticket)
      @current_user = FactoryBot.create(:user)
    end

    it 'お知らせレコードが保存されること' do
      @ticket.create_notification_request(@current_user)
      expect(@current_user.active_notifications.count).to eq 1
    end
  end

  it 'visitorで通知送信者が取得できること' do
    FactoryBot.build(:user)
    notification = FactoryBot.build(:notification)
    expect(notification.visitor).to be_present
  end

  it 'visitedで通知受信者が取得できること' do
    FactoryBot.build(:user)
    notification = FactoryBot.build(:notification)
    expect(notification.visited).to be_present
  end
end
