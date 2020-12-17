class CardsController < ApplicationController
  require 'payjp'

  def new
    @card = Card.where(user_id: current_user.id).first
    redirect_to action: 'show' if @card.present?
  end

  def create
    # 秘密鍵を登録し、起点となるオブジェクトを取得する
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    if params['payjp-token'].blank?
      redirect_to action: 'new', alert: 'クレジットカードを登録できませんでした。'
    else
      customer = Payjp::Customer.create(
        card: params['payjp-token']
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        render :show
      else
        render :new
      end
    end
  end

  def show
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      # カード登録画面にリダイレクトされる
      redirect_to action: 'new'
    else
      Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
      # Payjp::Customer.retrieveメソッドは顧客情報を取得するメソッド
      customer = Payjp::Customer.retrieve(card.customer_id)
      # cardsは顧客に紐づけられたカードオブジェクトのlistオブジェクト
      # 上で定義したcardからcard_idを取得し、retrieveでカード情報を取得している
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end
end
