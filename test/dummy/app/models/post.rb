class Post < ApplicationRecord
  belongs_to :user
  enum status: [:draft, :published, :archived]
end