class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates_uniqueness_of :user_id, scope: :ticket_id

  def create_notification_like(current_user)
    # すでに「通知」がされているか検索
    like_notification = Notification.where("visitor_id = ? and visited_id = ? and ticket_id = ? and action = ?", current_user.id, @ticket.seller_id, @ticket.id, "like")
    if like_notification.blank?
      @notification = current_user.active_notifications.new(
        visited_id: @ticket.seller_id,
        ticket_id: @ticket.id,
        action: "like"
      )
      if @notification.visited_id === current_user.id
        @notification.checked = true
      end
      @notification.save!
    end
  end

end
