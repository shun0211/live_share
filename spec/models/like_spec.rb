# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:ticket) { FactoryBot.build(:ticket) }

  it '一枚の投稿チケットに一人のユーザしかいいねレコードが作成できないこと' do
    described_class.create(user: user, ticket: ticket)
    duplicate_like = described_class.new(user: user, ticket: ticket)
    expect(duplicate_like).not_to be_valid
  end
end
