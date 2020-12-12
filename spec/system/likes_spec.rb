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
        wait_for_ajax do
          expect(user.likes.count).to eq 1
        end
      end
    end
  end
end
