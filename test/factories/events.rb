FactoryBot.define do
  factory :event do
    name { "MyString" }
    start_time { "2020-03-30 17:23:39" }
    end_time { "2020-03-30 17:23:39" }
    can_register { false }
    open_register { false }
    location { "MyString" }
    live_url { "MyString" }
    event_fee { 1 }
    pay_method { "MyString" }
  end
end
