class Room < ApplicationRecord
  has_many :messages
  has_many :entries
end
