# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user

  enum content_type: %i[plain_text link image video]

  validates :content, :user_id, presence: true
end
