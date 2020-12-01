require 'rails_helper'

RSpec.describe User, type: :model do
  # テストで使用するテストデータをセットアップ
  # 各exampleの前に実行される
  before do
    @user = FactoryBot.build(:user)
  end

  # ニックネーム、メールアドレス、パスワードがあれば有効な状態であること
  it "is valid with a nickname, email address and password" do
    expect(@user).to be_valid
  end

  # ニックネームがなければ無効な状態であること
  it "is invalid without a nickname" do
    @user.nickname = nil
    @user.valid?
    expect(@user).to_not be_valid
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without a email address" do
    @user.email = nil
    @user.valid?
    expect(@user).to_not be_valid
  end

  it "パスワードがなければ無効な状態であること" do
    @user.password = nil
    @user.valid?
    expect(@user).to_not be_valid
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    @user.email = "aaa@example.com"
    @user.save!
    duplicate_user = @user.dup
    duplicate_user.valid?
    expect(duplicate_user).to_not be_valid
  end

  it "パスワードが空白になっていないこと" do
    @user.password = " " * 8
    @user.valid?
    expect(@user).to_not be_valid
  end

  describe "password validation" do
    context "半角英数字7桁のとき" do
      it "正しくない" do
        @user.password = @user.password_confirmation = "a" * 6 + 1.to_s
        expect(@user).to_not be_valid
      end
    end

    context "半角英数字8桁のとき" do
      it "正しい" do
        @user.password = @user.password_confirmation = "a" * 7 + 1.to_s
        expect(@user).to be_valid
      end
    end

    context "半角英字8桁のとき" do
      it "正しくない" do
        @user.password = @user.password_confirmation = "a" * 8
        expect(@user).to_not be_valid
      end
    end

    context "数字8桁のとき" do
      it "正しくない" do
        @user.password = @user.password_confirmation = "1" * 8
        expect(@user).to_not be_valid
      end
    end
  end

  it "全文字小文字のemailと大文字を混ぜて登録されたアドレスが同じか" do
    @user.email = "aAa@exAmPLe.coM"
    @user.save!
    expect(@user.reload.email).to eq "aaa@example.com"
  end

  context "when email format is invalid" do
    it "emailのvalidateが正しく機能しているか" do
      expect(FactoryBot.build(:user, email: "aaa@example")).to_not be_valid
      expect(FactoryBot.build(:user, email: "aaaexample.com")).to_not be_valid
      expect(FactoryBot.build(:user, email: "@example.com")).to_not be_valid
      expect(FactoryBot.build(:user, email: "aaa@example,com")).to_not be_valid
    end
  end

  it "sold_ticketsでユーザが販売したチケットが取得できること" do
    ticket = FactoryBot.create(:ticket)
    expect(@user.sold_tickets.count).to eq 1
  end

  it "buyed_ticketsでユーザが購入したチケットが取得できること" do

  end

  it "passive_ticketsでユーザが受信したお知らせが取得できること" do

  end

  it "active_notificationsでユーザが送信したお知らせが取得できること" do

  end
end
