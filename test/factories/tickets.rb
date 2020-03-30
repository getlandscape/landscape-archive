FactoryBot.define do
  factory :ticket do
    user_id { 1 }
    event_id { 1 }
    status { "MyString" }
    paid_amount { 1 }
  end
end
