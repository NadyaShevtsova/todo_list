FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    user
  end
end
