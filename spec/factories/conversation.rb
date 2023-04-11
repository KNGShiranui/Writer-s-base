FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user
    association :recipient, factory: :second_user
  end

  factory :second_conversation, class: Conversation do
    association :sender, factory: :second_user
    association :recipient, factory: :third_user
  end

  # factory :third_conversation, class: Conversation do
  #   association :sender, factory: :third_user
  #   association :recipient, factory: :user
  # end
end
