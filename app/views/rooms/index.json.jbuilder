# frozen_string_literal: true

json.array! @messages do |message|
  json.page params[:page]
  json.id message.id
  json.user_id message.user_id
  json.created_at message.created_at
  json.content message.content
  json.user do
    json.avatar message.user.avatar.url
  end
end
