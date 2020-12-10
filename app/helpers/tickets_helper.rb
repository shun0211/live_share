# frozen_string_literal: true

module TicketsHelper
  def liked_by(user)
    likes.where(user_id: user.id).exists?
  end
end
