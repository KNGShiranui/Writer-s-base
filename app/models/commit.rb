class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :branch

  validates :message, presence: true
end
