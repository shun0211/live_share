class Ticket < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader

  belongs_to :event
end
