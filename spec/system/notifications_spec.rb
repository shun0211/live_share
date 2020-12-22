# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notification', type: :system do
  let(:user) { FactoryBot.create(:user, nickname: 'さかい') }
  let(:ticket) { FactoryBot.create(:ticket, seller: user) }
  let(:friend) { FactoryBot.create(:user, nickname: 'ひろちょ') }

  describe '行きたい!!機能関連の通知' do
    before do
      sign_in friend
      visit ticket_path(ticket)
    end

    context '他ユーザがチケットに行きたい!!ボタンをクリックした場合' do
      before do
        click_on '行きたい!!'
        sleep 2
      end

      it 'チケット投稿者に通知がいくこと', js: true do
        sign_out friend
        sign_in user
        visit notifications_path
        expect(page).to have_content 'ひろちょさんがあなたのチケットにいいねしました。'
      end
    end

    context '他ユーザがチケットに行きたい!!ボタンを連打(３回)クリックした場合' do
      before do
        click_on '行きたい!!'
        sleep 2
        click_on '行きたい!!'
        sleep 2
        click_on '行きたい!!'
        sleep 2
      end

      it 'チケット投稿者に一回のみ通知がいくこと', js: true do
        expect(friend.active_notifications.count).to eq 1
      end
    end

    context 'ログイン中のユーザが自分の投稿チケットの行きたい!!ボタンをクリックした場合' do
      before do
        sign_out friend
        sign_in user
        visit ticket_path(ticket)
        click_on '行きたい!!'
        sleep 2
      end

      it '通知がこないこと', js: true do
        expect(user.passive_notifications.all.count).to eq 0
      end
    end
  end

  describe 'コメント機能関連の通知' do
    before do
      sign_in friend
      visit ticket_path(ticket.id)
    end

    context '他ユーザがコメントした場合' do
      before do
        fill_in 'comment_content', with: '最高だね！'
        find('.far.fa-paper-plane').click
        sleep 2
      end

      it 'チケット投稿者に通知がいくこと', js: true do
        sign_out friend
        sign_in user
        find('.far.fa-bell').click
        expect(page).to have_content 'ひろちょさんがあなたのチケットにコメントしました。'
      end
    end

    context 'ログイン中のユーザが自分の投稿チケットにコメントした場合' do
      before do
        sign_out friend
        sign_in user
        visit ticket_path(ticket)
        fill_in 'comment_content', with: '最高だね！'
        find('.far.fa-paper-plane').click
        sleep 2
      end

      # it '通知がこないこと', js: true do
      #   expect(Notification.all.count).to eq 0
      # end
    end
  end

  # describe '購入希望関連の通知' do
  #   before do
  #     sign_in friend
  #     visit ticket_path(ticket.id)
  #   end

  #   context '他ユーザが購入希望をした場合' do
  #     before do
  #       click_on '購入を希望する'
  #     end

  #     it 'チケット投稿者に通知がいくこと' do
  #       sign_out friend
  #       sign_in user
  #       visit notifications_path
  #       expect(page).to have_content 'ひろちょさんからあなたのチケットに購入希望がありました。'
  #     end
  #   end
  # end

  describe 'メッセージ関連の通知' do
    let(:room) { Room.create! }

    before do
      sign_in friend
      Entry.create!(user: user, room: room)
      Entry.create!(user: friend, room: room)
      visit room_path(room)
    end

    context '他ユーザがメッセージを送信した場合' do
      before do
        fill_in 'content', with: 'はじめまして'
        find('.far.fa-paper-plane').click
        sleep 2
      end

      it '送信者のユーザに通知がこないこと', js: true do
        expect(friend.passive_notifications.count).to eq 0
      end

      it '送信先のユーザに通知がいくこと', js: true do
        sign_out friend
        sign_in user
        visit notifications_path
        expect(page).to have_content 'ひろちょさんからあなたにメッセージがありました。'
      end
    end
  end
end
