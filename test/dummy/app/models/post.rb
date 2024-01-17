class Post < ApplicationRecord
  belongs_to :user
  enum status: [:draft, :published, :archived]
  validates_length_of :title, minimum: 2, maximum: 50 
end
