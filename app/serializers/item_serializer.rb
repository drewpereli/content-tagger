# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :content, :content_type
end
