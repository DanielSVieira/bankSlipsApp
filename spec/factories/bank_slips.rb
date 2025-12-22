FactoryBot.define do
  factory :bank_slip do
     due_date { "2025-12-22" }
     total_in_cents { "9.99" }
     customer { "MyString" }
     status { "MyString" }
     extenal_id { "MyString" }
  end
end
