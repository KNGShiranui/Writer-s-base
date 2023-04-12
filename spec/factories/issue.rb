FactoryBot.define do
  factory :issue do
    name { "Issue_1" }
    description { "Description_1" }
    status { "open" }
    priority { "high" }
    association :user, factory: :user
    # user_id { 1 }
    association :repository, factory: :repository
    # repository_id { 1 }
  end

  factory :second_issue, class: Issue do
    name { "Issue_2" }
    description { "Description_2" }
    status { "closed" }
    priority { "high" }
    association :user, factory: :second_user
    association :repository, factory: :second_repository
  end
end
