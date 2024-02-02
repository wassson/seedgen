class User < ApplicationRecord
  has_many :posts

  validates :hourly_wage, presence: true
  validates :hourly_wage, numericality: { greater_than_or_equal_to: 16, less_than: 100 }
  validates :hourly_wage, numericality: { less_than: 99 }
  validates :hourly_wage, numericality: { in: 1..24 }
end