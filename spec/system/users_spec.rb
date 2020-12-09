require 'rails_helper'

RSpec.describe 'User', type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe 'ユーザ新規登録' do
    before do
      visit new_user_registration_path
    end

    context '新規ユーザ登録が成功した場合' do
      it 'トップページへ遷移すること' do
        fill_in 'ニックネーム', with: 'さかい'
        fill_in 'メールアドレス', with: 'aaa@example.com'
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード確認', with: 'password1'
        find_by(id: 'registration-btn').click
        # have_content：ページ内に特定の文字列が表示されていることを検証
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end

    context '新規ユーザ登録が失敗した場合' do
      it '新規ユーザ登録画面が再度表示されること' do
        fill_in 'ニックネーム', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード確認', with: ''
        find_by(id: 'registration-btn').click
        expect(page).to have_content '新規会員登録'
      end
    end

    context '簡単ログインボタンをクリックした場合' do
      it 'トップページへ遷移すること' do
        find_by(id: 'easy-login-registration').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
  end

  describe 'ユーザログイン' do
    before do
      visit login_path
    end

    context 'ログインに成功した場合' do
      it 'トップページへ遷移すること' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        find_by(id: 'login-btn').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end

    context 'ログインに失敗した場合' do
      it 'ログインページが再度表示されること' do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        find_by(id: 'login-btn').click
        expect(page).to have_content 'ログイン'
      end
    end

    context 'かんたんログインボタンをクリックした場合' do
      it 'トップページへ遷移すること' do
        find_by(id: 'easy-login-session').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
  end

  describe 'ログアウト' do
    before do
      sign_in user
      visit root_path
    end

    context 'ログアウトボタンをクリックした場合' do
      it 'ログアウトしトップページが表示されること' do
        find('.logout-button').click
        expect(page).to have_content('ログアウトしました。')
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end

  describe 'マイページ' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      find_by(id: 'login-btn').click
    end

    context 'トップページにて' do
      it 'ハンバーガーメニューにマイページと表示されること' do
        expect(page).to have_content('マイページ')
      end
    end

    context 'マイページにて' do
      before do
        visit mypage_path
      end

      it 'ログイン中のユーザのマイページに遷移すること' do
        expect(page).to have_content user.nickname
      end

      it '「編集する」リンクが表示されること' do
        expect(page).to have_content '編集する'
      end
    end

    context 'プロフィール編集画面にて' do
      before do
        visit edit_user_registration_path(user)
      end

      it 'プロフィール編集画面が表示される' do
        expect(page).to have_content 'プロフィール画像を変更する'
      end

      it 'ニックネーム編集フォームにログイン中のユーザのニックネームが表示されること' do
        expect(page).to have_field 'ニックネーム', with: user.nickname
      end

      it 'プロフィール編集フォームにログイン中のユーザのプロフィールが表示されること' do
        expect(page).to have_field 'プロフィール', with: user.profile
      end

      context '編集を行い、更新ボタンをクリックした場合' do
        it '編集に成功する' do
          fill_in 'ニックネーム', with: 'さかい'
          fill_in 'プロフィール', with: 'よろしくお願いします！'
          find('.btn.btn-warning.update-btn').click
          expect(page).to have_content 'アカウント情報を変更しました。'
          expect(page).to have_content 'さかい'
          expect(page).to have_content 'よろしくお願いします！'
          expect(page).to have_current_path user_path(user), ignore_query: true
        end

        it '編集に失敗する' do
          fill_in 'ニックネーム', with: ''
          find('.btn.btn-warning.update-btn').click
          expect(page).to have_content 'ニックネームを入力してください'
          expect(page).to have_content 'プロフィール画像を変更する'
        end
      end
    end
  end
end
