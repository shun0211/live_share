# frozen_string_literal: true

module ApplicationHelper
  def unchecked_notifications
    current_user.passive_notifications.where(checked: false)
  end
end
