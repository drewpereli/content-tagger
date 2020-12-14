# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    content { "my item content" }
    file { Rack::Test::UploadedFile.new("spec/fixtures/my-img.jpg", "image/jpg") }
  end
end
