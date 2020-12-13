# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password { "Password123" }
    password_confirmation { "Password123" }
  end
end
