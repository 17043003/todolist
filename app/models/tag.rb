class Tag < ApplicationRecord
  belongs_to :user
  has_many :tasks

  validates :name, presence: true, length: { maximum: 20 }
end
