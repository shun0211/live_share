# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Like', type: :system do
  describe '行きたい!!機能' do
    let(:user) { FactoryBot.create(:user, nickname: 'さかい') }
    let(:ticket) { FactoryBot.create(:ticket) }

    before do
      sign_in user
      visit ticket_path(ticket)
    end

    context '行きたい!!ボタンを押してない状態でクリックする場合' do
      it '行きたい!!の数が一つ増える', js: true do
        click_on '行きたい!!'
        sleep 2
        expect(user.likes.count).to eq 1
      end

      # it '行きたい!!の数が一つ増える', js: true do
      #   expect{
      #     find_by_id('like').click
      #     wait_for_ajax
      #   }.to change{ user.likes.count }.by(1)
      # end
    end

    context '行きたい!!ボタンを押した状態でクリックする場合' do
      it '行きたい!!の数が一つ減る', js: true do
        click_on '行きたい!!'
        sleep 2
        click_on '行きたい!!'
        sleep 2
        expect(user.likes.count).to eq 0
      end
    end

    context 'ログイン中でないユーザが行きたい!!ボタンをクリックする場合' do
      before do
        sign_out user
        visit ticket_path(ticket)
      end

      it '行きたい!!の数が変化しない', js: true do
        find_by_id('like').click
        sleep 2
        expect(page).to have_content 0
      end
    end
  end
end
