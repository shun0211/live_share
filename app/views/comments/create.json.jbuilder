# frozen_string_literal: true

json.extract! @comment, :id, :content, :created_at, :updated_at
json.userNickname @comment.user.nickname
json.userAvatar @comment.user.avatar.url
json.seller true if @comment.ticket.seller_id === current_user.id
