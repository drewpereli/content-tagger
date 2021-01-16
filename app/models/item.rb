# frozen_string_literal: true

class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_one_attached :file

  enum content_type: %i[text link file]

  validates :user_id, presence: true

  validate :content_or_file

  def content_or_file
    errors.add(:item, "Either 'content' or 'file' must be included") unless content.present? || file.present?
  end

  def file_url
    return unless file.present?

    if Rails.application.config.active_storage.service == :local
      local_file_url
    else
      file_blob_path
    end
  end

  def local_file_url
    return unless file.present?

    protocol = Rails.application.routes.default_url_options[:protocol]
    host = Rails.application.routes.default_url_options[:host]
    File.join("#{protocol}://#{host}", file_blob_path)
  end

  def file_blob_path
    return unless file.present?

    rails_blob_path(file)
  end
end
