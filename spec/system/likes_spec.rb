require 'rails_helper'

RSpec.describe 'Like', type: :system do
  describe '行きたい!!機能' do
    before do
      let(:user) { FactoryBot.create(:user, nickname: 'さかい') }
      let(:ticket) { FactoryBot.create(:ticket) }
      sign_in user
      visit ticket_path(ticket)
    end

    it ''
  end

end
