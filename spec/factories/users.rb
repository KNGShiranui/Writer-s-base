FactoryBot.define do
  factory :user do
    name { "KNG1" }
    email { "KNG1@example.com" }
    password { "11101252" }
    password_confirmation { "11101252" }
    admin { true }
  end

  factory :second_user, class: User do
    name { "KNG2" }
    email { "KNG2@example.com" }
    password { "11101252" }
    password_confirmation { "11101252" }
    admin { false }
  end

  factory :third_user, class: User do
    name { "KNG3" }
    email { "KNG3@example.com" }
    password { "11101252" }
    password_confirmation { "11101252" }
    admin { false }
  end
end