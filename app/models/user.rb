class User < ApplicationRecord
  has_secure_password

  has_many :tasks
  has_many :tags

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
