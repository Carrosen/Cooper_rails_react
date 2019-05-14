FactoryBot.define do
  factory :user do
    email { "zane@craft.se" }
    password { "pswrd12345" }
    password_confirmation { "pswrd12345" }
  end
end
