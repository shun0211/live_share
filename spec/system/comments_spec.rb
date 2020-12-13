require 'rails_helper'

RSpec.describe 'Comment', type: :system do
  let(:user) { FactoryBot.create(:user, nickname: 'さかい') }
  let(:ticket) { FactoryBot.create(:ticket) }

  describe 'コメント投稿機能' do
    context 'ユーザがログイン中の場合' do
      before do
        sign_in user
        visit ticket_path(ticket)
      end

      it 'コメントのテキストボックスが表示されること' do
        expect(page).to have_selector 'input#comment_content'
      end

      it 'コメント投稿後、投稿したコメントが表示されること', js: true do
        fill_in 'comment_content', with: '最高だね！'
        find('.far.fa-paper-plane').click
        sleep 2
        expect(page).to have_content '最高だね！'
      end
    end

    context 'ユーザがログイン中でない場合' do
      before do
        visit ticket_path(ticket)
      end

      it 'コメントのテキストボックスが表示されないこと' do
        expect(page).to_not have_selector 'input#comment_content'
      end
    end
  end

  describe 'コメント削除機能' do
    context 'ログイン中のユーザが投稿したコメントの場合' do
      before do
        sign_in user
        FactoryBot.create(:comment, user: user, ticket: ticket)
        visit ticket_path(ticket)
      end

      it 'コメント削除ボタンが表示されること' do
        expect(page).to have_selector '.fas.fa-trash-alt'
      end

      it 'コメント削除ボタンをクリックすると、削除されること', js: true do
        expect(page).to have_content '値下げお願いできないでしょうか'
        find('.fas.fa-trash-alt').click
        sleep 2
        expect(page).to_not have_content '値下げお願いできないでしょうか'
      end
    end

    context 'ログイン中のユーザが投稿したコメントでない場合' do
      before do
        sign_in user
        FactoryBot.create(:comment, ticket: ticket)
        visit ticket_path(ticket)
      end

      it 'コメント削除ボタンが表示されないこと' do
        expect(page).to_not have_selector '.fas.fa-trash-alt'
      end
    end

    context 'ユーザがログイン中でない場合' do
      before do
        FactoryBot.create(:comment, ticket: ticket)
        visit ticket_path(ticket)
      end

      it 'コメント削除バタンが表示されないこと' do
        expect(page).to_not have_selector '.fas.fa-trash-alt'
      end
    end
  end
end
