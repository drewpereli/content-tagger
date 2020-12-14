# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :content, :content_type
  attribute :file_url, if: :file?

  def file?
    object.file.present?
  end
end
