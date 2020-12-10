# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # テストで使用するテストデータをセットアップ
  # 各exampleの前に実行される
  before do
    @user = FactoryBot.build(:user)
  end

  # ニックネーム、メールアドレス、パスワードがあれば有効な状態であること
  it 'is valid with a nickname, email address and password' do
    expect(@user).to be_valid
  end

  # ニックネームがなければ無効な状態であること
  it 'is invalid without a nickname' do
    @user.nickname = nil
    @user.valid?
    expect(@user).not_to be_valid
  end

  # メールアドレスがなければ無効な状態であること
  it 'is invalid without a email address' do
    @user.email = nil
    @user.valid?
    expect(@user).not_to be_valid
  end

  it 'パスワードがなければ無効な状態であること' do
    @user.password = nil
    @user.valid?
    expect(@user).not_to be_valid
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    @user.email = 'aaa@example.com'
    @user.save!
    duplicate_user = @user.dup
    duplicate_user.valid?
    expect(duplicate_user).not_to be_valid
  end

  it 'パスワードが空白になっていないこと' do
    @user.password = ' ' * 8
    @user.valid?
    expect(@user).not_to be_valid
  end

  describe 'password validation' do
    context '半角英数字7桁のとき' do
      it '正しくない' do
        @user.password = @user.password_confirmation = 'a' * 6 + 1.to_s
        expect(@user).not_to be_valid
      end
    end

    context '半角英数字8桁のとき' do
      it '正しい' do
        @user.password = @user.password_confirmation = 'a' * 7 + 1.to_s
        expect(@user).to be_valid
      end
    end

    context '半角英字8桁のとき' do
      it '正しくない' do
        @user.password = @user.password_confirmation = 'a' * 8
        expect(@user).not_to be_valid
      end
    end

    context '数字8桁のとき' do
      it '正しくない' do
        @user.password = @user.password_confirmation = '1' * 8
        expect(@user).not_to be_valid
      end
    end
  end

  it '全文字小文字のemailと大文字を混ぜて登録されたアドレスが同じか' do
    @user.email = 'aAa@exAmPLe.coM'
    @user.save!
    expect(@user.reload.email).to eq 'aaa@example.com'
  end

  context 'when email format is invalid' do
    it 'emailのvalidateが正しく機能しているか' do
      expect(FactoryBot.build(:user, email: 'aaa@example')).not_to be_valid
      expect(FactoryBot.build(:user, email: 'aaaexample.com')).not_to be_valid
      expect(FactoryBot.build(:user, email: '@example.com')).not_to be_valid
      expect(FactoryBot.build(:user, email: 'aaa@example,com')).not_to be_valid
    end
  end

  it 'sold_ticketsでユーザが販売したチケットが取得できること' do
    ticket = FactoryBot.build(:ticket, seller: @user)
    ticket.save!
    expect(@user.sold_tickets.count).to eq 1
  end

  it 'buyed_ticketsでユーザが購入したチケットが取得できること' do
    ticket = FactoryBot.build(:ticket, buyer: @user)
    ticket.save!
    expect(@user.buyed_tickets.count).to eq 1
  end

  it 'passive_ticketsでユーザが受信したお知らせが取得できること' do
    notification = FactoryBot.build(:notification, visited: @user)
    notification.save!
    expect(@user.passive_notifications.count).to eq 1
  end

  it 'active_notificationsでユーザが送信したお知らせが取得できること' do
    notification = FactoryBot.build(:notification, visitor: @user)
    notification.save!
    expect(@user.active_notifications.count).to eq 1
  end

  describe '#self.guest' do
    context 'usersテーブルにゲストユーザが登録済みの場合' do
      described_class.create(email: 'guest@example.com', password: 'password0', nickname: 'ゲストユーザ')
      it 'ゲストユーザを取得すること' do
        guest_user = described_class.guest
        expect(guest_user.nickname).to eq 'ゲストユーザ'
      end
    end

    context 'usersテーブルにゲストユーザが登録されていない場合' do
      it 'ゲストユーザを作成すること' do
        guest_user = described_class.guest
        expect(guest_user.nickname).to eq 'ゲストユーザ'
      end
    end
  end
end
