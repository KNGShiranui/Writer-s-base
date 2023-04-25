class Branch < ApplicationRecord
  belongs_to :repository
  belongs_to :user
  has_many :commits, dependent: :destroy
  has_many :documents, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :repository_id }
end
