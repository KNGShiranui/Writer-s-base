class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :branch
  belongs_to :document
  
  validates :message, presence: true
end
