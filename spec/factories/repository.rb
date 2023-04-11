FactoryBot.define do
  factory :repository do
    name { "Repository_1" }
    description { "Description_1" }
    status { "open" }
    priority { "high" }
    association :user, factory: :user
  end

  factory :second_repository, class: Repository do
    name { "Repository_2" }
    description { "Description_2" }
    status { "open" }
    priority { "low" }
    association :user, factory: :second_user
  end

  factory :third_repository, class: Repository do
    name { "Repository_3" }
    description { "Description_3" }
    status { "closed" }
    priority { "high" }
    association :user, factory: :third_user
  end
end
