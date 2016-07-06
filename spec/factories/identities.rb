FactoryGirl.define do
  factory :facebook_identity do
    uid { Faker::Number.number(16) }
    provider "facebook"
    user
  end
end
