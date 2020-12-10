# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ticket', type: :system do
  let(:user) { FactoryBot.create(:user, nickname: 'さかい') }

  describe 'チケット投稿機能' do
    before do
      sign_in user
    end

  context 'チケット投稿に成功した場合' do
    it 'トップページに遷移すること', js: true do
      fill_in ''
    end
  end

end
