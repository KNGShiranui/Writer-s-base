FactoryBot.define do
  factory :branch do
    name { "Branch_1" }
    status { "0" }
    association :repository, factory: :repository
    association :user, factory: :user
  end

  factory :second_branch, class: Branch do
    name { "Branch_2" }
    status { "0" }
    association :repository, factory: :repository
    association :user, factory: :user
  end

  factory :third_branch, class: Branch do
    name { "Branch_3" }
    status { "0" }
    association :repository, factory: :repository
    association :user, factory: :user
  end
end
