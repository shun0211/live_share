# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ticket', type: :system do
  let(:user) { FactoryBot.create(:user, nickname: 'さかい') }

  describe 'チケット投稿機能' do
    before do
      sign_in user
      visit new_ticket_path
    end

    context '必須項目をすべて入力し、出品ボタンを押した場合' do
      before do
        # attach_file 'ラベル名', '画像のパス'
        attach_file('thumbnail-uploadButton', "#{Rails.root}/spec/fixtures/thumbnail.jpeg", make_visible: true)
        fill_in 'event_name-form', with: 'YON FES 2021'
        fill_in '公演日', with: '2020-12-11'
        fill_in '開催地', with: 'モリコロパーク'
        select '2枚', from: '枚数'
        fill_in '席種', with: 'なし'
        select '送料込み(出品者負担)', from: '配送料の負担'
        fill_in '受け渡し方法', with: '名古屋駅手渡し'
        fill_in '販売価格', with: 7000
        click_button '出品する'
      end

      it 'トップページに遷移すること', js: true do
        using_wait_time(7) do
          expect(page).to have_current_path root_path
        end
      end
    end
  end
end
