# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ticket', type: :system do
  let(:user) { FactoryBot.create(:user, nickname: 'さかい') }
  let(:ticket) { FactoryBot.build(:ticket) }

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
        using_wait_time(5) do
          expect(page).to have_current_path root_path
        end
      end
    end

    context '必須項目が未入力のまま、出品ボタンを押した場合' do
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
      end

      it '公演名が入力されていない場合、エラーメッセージが表示されること', js: true do
        fill_in 'event_name-form', with: ''
        click_button '出品する'
        expect(page).to have_content '公演名を選択するか30文字以内で入力してください'
      end

      it '開催地が入力されていない場合、エラーメッセージが表示されること', js: true do
        fill_in '開催地', with: ''
        click_button '出品する'
        expect(page).to have_content '開催地を30文字以下で入力してください'
      end

      it '枚数が入力されていない場合、エラーメッセージが表示されること', js: true do
        select '選択してください', from: '枚数'
        click_button '出品する'
        expect(page).to have_content '枚数を選択してください'
      end

      it '配送料の負担が入力されていない場合、エラーメッセージが表示されること', js: true do
        select '選択してください', from: '配送料の負担'
        click_button '出品する'
        expect(page).to have_content '配送料の負担を選択してください'
      end

      it '受け渡し方法が入力されていない場合、エラーメッセージが表示されること', js: true do
        fill_in '受け渡し方法', with: ''
        click_button '出品する'
        expect(page).to have_content '受け渡し方法を30文字以内で入力してください'
      end

      it '価格が入力されていない場合、エラーメッセージが表示されること', js: true do
        fill_in '販売価格', with: ""
        click_button '出品する'
        expect(page).to have_content '販売価格を300 ~ 99,999円で入力してください'
      end
    end
  end

  describe 'チケット詳細画面' do
    before do
      sign_in user
      ticket = FactoryBot.create(:ticket)
      visit ticket_path(ticket)
    end

    it '投稿されたチケットの公演名が表示されていること' do
      expect(page).to have_content 'YON FES 2021'
    end

    it '投稿されたチケットの公演日が表示されていること' do
      expect(page).to have_content '2021年4月3日'
    end

    it '投稿されたチケットの開催地が表示されていること' do
      expect(page).to have_content 'モリコロパーク'
    end

    it '投稿されたチケットの枚数が表示されていること' do
      expect(page).to have_content '2 枚'
    end

    it '投稿されたチケットの席種が表示されていること' do
      expect(page).to have_content '立ち見'
    end

    it '投稿されたチケットの配送料の負担が表示されていること' do
      expect(page).to have_content '送料込み(出品者負担)'
    end

    it '投稿されたチケットの受け渡し方法が表示されていること' do
      expect(page).to have_content '名古屋駅手渡し'
    end

    it '投稿されたチケットの販売価格が表示されていること' do
      expect(page).to have_content '5000'
    end

    it '投稿されたチケットの備考が表示されていること' do
      expect(page).to have_content '複数チケットが当たったので、出品します。できればフォーリミのファンの方に譲りたいと思っています。よろしくお願いします！'
    end

    context 'ログイン中のユーザ以外が投稿したチケットの場合' do
      it '購入希望ボタンが表示されていること' do
        expect(page).to have_content '購入を希望する'
      end

      it 'メッセージ送信ボタンが表示されていること' do
        expect(page).to have_content 'メッセージを送る'
      end
    end

    context 'ログイン中のユーザが投稿したチケットの場合' do
      before do
        current_user_ticket = FactoryBot.create(:ticket, seller: user)
        visit ticket_path(current_user_ticket)
      end

      it '編集ボタンが表示されていること' do
        expect(page).to have_content '編集する'
      end

      it '削除ボタンが表示されていること' do
        expect(page).to have_content '削除する'
      end
    end
  end

  describe 'チケット編集機能' do
    before do
      sign_in user
      @current_user_ticket = FactoryBot.create(:ticket, seller: user)
      visit ticket_path(@current_user_ticket)
    end

    it '「編集するボタン」をクリックした場合、編集画面に遷移すること' do
      click_on '編集する'
      expect(page).to have_current_path edit_ticket_path(@current_user_ticket)
    end

    context '編集画面に遷移した場合' do
      before do
        visit edit_ticket_path(@current_user_ticket)
      end

      it '公演名フィールドに編集前データがセットされていること' do
        expect(page).to have_field 'event_name-form', with: @current_user_ticket.event_name
      end

      it '公演日フィールドに編集前データがセットされていること' do
        expect(page).to have_field '公演日', with: @current_user_ticket.event_date
      end

      it '枚数フィールドに編集前データがセットされていること' do
        expect(page).to have_field '枚数', with: @current_user_ticket.number_of_sheets
      end

      it '席種フィールドに編集前データがセットされていること' do
        expect(page).to have_field '席種', with: @current_user_ticket.sheet_type
      end

      it '配送料の負担フィールドに編集前データがセットされていること' do
        expect(page).to have_field '配送料の負担', with: @current_user_ticket.shipping
      end

      it '受け渡し方法フィールドに編集前データがセットされていること' do
        expect(page).to have_field '受け渡し方法', with: @current_user_ticket.delivery_method
      end

      it '価格フィールドに編集前データがセットされていること' do
        expect(page).to have_field '販売価格', with: @current_user_ticket.price
      end

      it '備考フィールドに編集前データがセットされていること' do
        expect(page).to have_field '備考', with: @current_user_ticket.description
      end
    end

    context '項目を一部編集をし、編集するボタンをクリックした場合' do
      it '編集に成功する', js: true do
        visit edit_ticket_path(@current_user_ticket)
        fill_in 'event_name-form', with: 'MET ROCK FES 2021'
        click_button '編集する'
        # using_wait_time(5) do
          expect(page).to have_content 'MET ROCK FES 2021'
          expect(page).to have_current_path ticket_path(@current_user_ticket)
        # end
      end

      it '編集に失敗する', js: true do
        visit edit_ticket_path(@current_user_ticket)
        fill_in '開催地', with: ''
        click_button '編集する'
        expect(page).to have_content '開催地を30文字以下で入力してください'
      end
    end
  end

  describe 'チケット削除機能' do
    before do
      sign_in user
      current_user_ticket = FactoryBot.create(:ticket, seller: user)
      visit ticket_path(current_user_ticket)
    end

    context '削除ボタンをクリックした場合' do
      before do
        click_on '削除する'
        page.driver.browser.switch_to.alert.accept
      end

      it '投稿が削除されること', js: true do
        sleep 2
        expect(user.sold_tickets.size).to eq 0
      end

      it 'トップページへ遷移すること', js: true do
        expect(page).to have_current_path root_path
      end
    end
  end
end
