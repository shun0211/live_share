class Ticket < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
end
