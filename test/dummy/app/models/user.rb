class User < ApplicationRecord
  has_many :posts

  validates :hourly_wage, presence: true
  validates :hourly_wage, numericality: { greater_than_or_equal_to: 16 }
end