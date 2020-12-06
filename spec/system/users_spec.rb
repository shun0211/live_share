require 'rails_helper'

RSpec.describe "User", type: :system do
  describe "ユーザ新規登録" do
    before do
      visit new_user_registration_path
    end
    context "新規ユーザ登録が成功した場合" do
      it "トップページへ遷移する" do
        fill_in "ニックネーム", with: "さかい"
        fill_in "メールアドレス", with: "aaa@example.com"
        fill_in "パスワード", with: "password1"
        fill_in 'パスワード確認', with: 'password1'
        find_by_id('registration-btn').click
        # have_content：ページ内に特定の文字列が表示されていることを検証
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
    context "新規ユーザ登録が失敗した場合" do
      it "新規ユーザ登録画面が再度表示される" do
        fill_in "ニックネーム", with: ""
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        fill_in 'パスワード確認', with: ""
        find_by_id('registration-btn').click
        expect(page).to have_content "新規会員登録"
      end
    end
    context "簡単ログインボタンをクリックした場合" do
      it "トップページへ遷移する" do
        find_by_id('easy-login-registration').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
  end

  describe "ユーザログイン" do
    before do
      visit login_path
    end
    let(:user){ FactoryBot.create(:user) }
    context "ログインに成功した場合" do
      it "トップページへ遷移する" do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        find_by_id('login-btn').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
    context "ログインに失敗した場合" do
      it "ログインページが再度表示される" do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        find_by_id('login-btn').click
        expect(page).to have_content "ログイン"
      end
    end
    context "かんたんログインボタンをクリックした場合" do
      it "トップページへ遷移する" do
        find_by_id('easy-login-session').click
        expect(page).to have_content "WE'LL CONNECT MUSIC FANS"
      end
    end
  end
end
