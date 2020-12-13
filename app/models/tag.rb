# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, length: {maximum: 30}
end
