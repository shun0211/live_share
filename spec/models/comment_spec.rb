# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.build(:comment) }

  it 'コメントがなければ無効な状態であること' do
    # comment.content = nil
    comment.valid?
    expect(comment).not_to be_valid
  end

  it 'コメントが空白の場合、無効な状態であること' do
    comment.content = ' '
    comment.valid?
    expect(comment).not_to be_valid
  end
end
