FactoryBot.define do
  factory :document do
    name { "Document_1" }
    content { "Content_1" }
    association :user, factory: :user
    association :branch, factory: :branch
  end

  factory :second_document, class: Document do
    name { "Document_2" }
    content { "Content_2" }
    association :user, factory: :user
    association :branch, factory: :branch
  end
end
