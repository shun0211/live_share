require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "モデルのバリデーション" do
    # letは遅延評価されるという特徴を持ち、呼ばれるまで呼び出されない
    let(:ticket){ FactoryBot.build(:ticket) }
    let(:user){ FactoryBot.build(:user) }
    it "thumbnail, event_name, event_date, venue, number_of_sheets, shipping, delivery_method, priceがあれば有効な状態であること" do
      a_ticket = Ticket.new(thumbnail: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/thumbnail.jpeg')),
                          event_name: "YON FES 2021",
                          event_date: "2021-04-03",
                          venue: "モリコロパーク",
                          number_of_sheets: 2,
                          shipping: 1,
                          delivery_method: "名古屋駅手渡し",
                          price: 5000,
                          seller: user)
      expect(a_ticket).to be_valid
    end

    it "thumbnailがなければ無効な状態であること" do
      ticket.thumbnail = nil
      expect(ticket).to_not be_valid
    end

    it "event_nameがなければ無効な状態であること" do
      ticket.event_name = nil
      expect(ticket).to_not be_valid
    end

    context "event_nameが30文字の場合" do
      it "有効であること" do
        ticket.event_name = "a" * 30
        expect(ticket).to be_valid
      end
    end

    context "event_nameが31文字の場合" do
      it "無効であること" do
        ticket.event_name = "a" * 31
        expect(ticket).to_not be_valid
      end
    end

    it "event_dateがなければ無効な状態であること" do
      ticket.event_date = nil
      expect(ticket).to_not be_valid
    end

    it "venueがなければ無効な状態であること" do
      ticket.venue = nil
      expect(ticket).to_not be_valid
    end

    context "venueが30文字の場合" do
      it "有効であること" do
        ticket.venue = "a" * 30
        expect(ticket).to be_valid
      end
    end

    context "venueが31文字の場合" do
      it "無効であること" do
        ticket.venue = "a" * 31
        expect(ticket).to_not be_valid
      end
    end

    it "number_of_sheetsがなければ無効な状態であること" do
      ticket.number_of_sheets = nil
      expect(ticket).to_not be_valid
    end

    it "shippingがなければ無効な状態であること" do
      ticket.shipping = nil
      expect(ticket).to_not be_valid
    end

    it "delivery_methodがなければ無効な状態であること" do
      ticket.delivery_method = nil
      expect(ticket).to_not be_valid
    end

    context "delivery_methodが30文字の場合" do
      it "有効であること" do
        ticket.delivery_method = "a" * 30
        expect(ticket).to be_valid
      end
    end

    context "delivery_methodが31文字の場合" do
      it "無効であること" do
        ticket.delivery_method = "a" * 31
        expect(ticket).to_not be_valid
      end
    end

    it "priceがなければ無効な状態であること" do
      ticket.price = nil
      expect(ticket).to_not be_valid
    end

    context "priceが301の場合" do
      it "有効であること" do
        ticket.price = 301
        expect(ticket).to be_valid
      end
    end

    context "priceが300の場合" do
      it "無効であること" do
        ticket.price = 300
        expect(ticket).to_not be_valid
      end
    end

    context "priceが99998の場合" do
      it "有効であること" do
        ticket.price = 99998
        expect(ticket).to be_valid
      end
    end

    context "priceが99999の場合" do
      it "無効であること" do
        ticket.price = 99999
        expect(ticket).to_not be_valid
      end
    end

    context "priceが数字以外の場合" do
      it "無効であること" do
        ticket.price = "aaa"
        expect(ticket).to_not be_valid
      end
    end
  end
end
