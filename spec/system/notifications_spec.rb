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
        expect(Notification.all.count).to eq 0
      end
    end
  end

  describe 'コメント機能関連の通知' do
    before do
      sign_in friend
      visit ticket_path(ticket)
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
        visit notifications_path
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

      it '通知がこないこと', js: true do
        expect(Notification.all.count).to eq 0
      end
    end
  end
end
