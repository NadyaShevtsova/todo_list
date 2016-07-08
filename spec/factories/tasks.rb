FactoryGirl.define do
  factory :task do
    name         { Faker::Company.name }
    deadline     { Faker::Date.forward(2) }
    mark_as_done false
    project
  end


  factory :task_done, parent: :task do
    deadline     { Faker::Date.backward(2) }
    mark_as_done false
  end
end
