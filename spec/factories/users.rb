require "securerandom"

FactoryBot.define do
  factory :user do
    email { "user-#{SecureRandom.uuid}@mail.com" }
    password { "password" }
  end
end
