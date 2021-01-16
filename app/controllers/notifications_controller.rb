# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_search_form

  def index
    @notifications = current_user.passive_notifications
  end

  private

  def set_search_form
    @q = Ticket.ransack(params[:q])
  end
end
