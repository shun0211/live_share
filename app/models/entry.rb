# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :room
  belongs_to :user
end
