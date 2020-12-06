require 'rails_helper'

RSpec.describe "Room", type: :system do
  let(:user){ FactoryBot.create(:user, nickname: "さかい") }
  let(:friend){ FactoryBot.create(:user, nickname: "木内") }
  let(:other_friend){ FactoryBot.create(:user, nickname: "ひろちょ") }
  describe "DMテスト" do
    before do
      sign_in user
    end
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
    end
  end
end
