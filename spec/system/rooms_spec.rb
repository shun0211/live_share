require 'rails_helper'

RSpec.describe "Room", type: :system do
  let(:user){ FactoryBot.create(:user, nickname: "さかい") }
  let(:friend){ FactoryBot.create(:user, nickname: "木内") }
  let(:other_friend){ FactoryBot.create(:user, nickname: "ひろちょ") }
  before do
    sign_in user
  end
  describe "メッセージ一覧画面" do
    context "DMをしたことがない場合" do
      it "サイドバーにユーザが表示されないこと" do
        visit rooms_path
        expect(page).to have_content "まだメッセージをしているユーザはいません。"
      end
    end
    context "過去にDMをしたことがある場合" do
      before do
        @room = Room.create
        Entry.create(user: user, room: @room)
        Entry.create(user: friend, room: @room)
        Message.create(user: user, room: @room, content: "住所をお聞きしてもよろしいですか？")

        @active_room = Room.create
        Entry.create(user: user, room: @active_room)
        Entry.create(user: other_friend, room: @active_room)
        Message.create(user: user, room: @active_room, content: "購入希望させてもらいました！")
        visit rooms_path
      end
      it "過去にDMしたユーザが表示されること" do
        expect(page).to have_content "木内"
        expect(page).to have_content "ひろちょ"
      end
      it "メッセージ画面に最近やりとりしたユーザとのメッセージが表示されること" do
        expect(page).to have_selector '.partner', text: 'ひろちょ'
        expect(page).to have_selector 'input#content'
        expect(page).to have_content "購入希望させてもらいました！"
      end
      it 'メッセージが送信できること', js: true do
        fill_in 'content', with: 'はじめまして'
        find('.far.fa-paper-plane').click
        expect(page).to have_content 'はじめまして'
      end
    end
  end

  describe "メッセージ詳細画面" do
    before do
      @room = Room.create
      Entry.create(user: user, room: @room)
      Entry.create(user: friend, room: @room)
      Message.create(user: user, room: @room, content: "住所をお聞きしてもよろしいですか？")

      @active_room = Room.create
      Entry.create(user: user, room: @active_room)
      Entry.create(user: other_friend, room: @active_room)
      Message.create(user: user, room: @active_room, content: "購入希望させてもらいました！")
    end
    context "メッセージが100件ある場合" do
      before do
        FactoryBot.create_list(:message, 100, user: user, room: @active_room)
        visit room_path(@active_room.id)
      end
      it "メッセージが30件のみ表示されること" do
        expect(all('.message').size).to eq 30
      end
      it "最新のメッセージが表示されていること" do
        expect(page).to have_content "Hello, World!! 200個目"
      end
      it "最新のメッセージがメッセージ欄の一番下に表示されていること" do
        expect(first(:css, '.message').text).to eq "Hello, World!! 271個目"
      end
    end
    context 'サイドバーのユーザをクリックした場合' do
      before do
        visit room_path(@active_room.id)
      end
      it "クリックしたユーザとのメッセージ画面が表示されること" do
        click_on '木内'
        expect(current_path).to eq room_path(@room.id)
        expect(page).to have_content('住所をお聞きしてもよろしいですか？')
      end
    end
    it 'メッセージが送信できること', js: true do
      visit room_path(@active_room.id)
      fill_in 'content', with: 'はじめまして'
      find('.far.fa-paper-plane').click
      expect(page).to have_content 'はじめまして'
    end
  end
end
