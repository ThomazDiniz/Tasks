FactoryBot.define do
  factory :task do
    association :user
    title { "Test Task" }
    description { "Test Description" }
    status { "pending" }
    due_date { Date.current + 1.day }
  end
end

