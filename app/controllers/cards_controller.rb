# frozen_string_literal: true

class CardsController < ApplicationController
  require 'payjp'

  before_action :set_search_form, only: %w[new show]

  def new
    card = Card.where(user_id: current_user.id).first
    redirect_to card_path(card) if card.present?
  end

  def create
    # 秘密鍵を登録し、起点となるオブジェクトを取得する
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    if params['payjp-token'].blank?
      redirect_to new_card_path, alert: 'クレジットカードを登録できませんでした。'
    else
      customer = Payjp::Customer.create(
        card: params['payjp-token']
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to card_path(@card)
      else
        render :new
      end
    end
  end

  def show
    @card = Card.where(user_id: current_user.id).first
    if @card.blank?
      # カード登録画面にリダイレクトされる
      redirect_to new_card_path
    else
      Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
      # Payjp::Customer.retrieveメソッドは顧客情報を取得するメソッド
      customer = Payjp::Customer.retrieve(@card.customer_id)
      # cardsは顧客に紐づけられたカードオブジェクトのlistオブジェクト
      # 上で定義したcardからcard_idを取得し、retrieveでカード情報を取得している
      @registration_card = customer.cards.retrieve(@card.card_id)
      brand = @registration_card.brand
      case brand
      when 'Visa'
        @card_src = 'visa.png'
      when 'JCB'
        @card_src = 'jcb.png'
      when 'MasterCard'
        @card_src = 'mastercard.png'
      when 'American Express'
        @card_src = 'americanexpress.png'
      when 'Diners Club'
        @card_src = 'dinersclub.png'
      when 'Discover'
        @card_src = 'discover.png'
      end
    end
  end

  def destroy
    @card = Card.find(params[:id])
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    customer = Payjp::Customer.retrieve(@card.customer_id)
    customer.delete
    @card.delete
    flash[:notice] = '登録されていたクレジットカードが削除されました。'
    redirect_to new_card_path
  end

  def checkout
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    customer = Payjp::Customer.create(
      card: params['payjp-token']
    )
    @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
    @card.save!
    @ticket = Ticket.find(params[:ticket_id])
    render 'shared/for_redirect_to_request', layout: false
  end

  private

  def set_search_form
    @q = Ticket.ransack(params[:q])
  end
end
