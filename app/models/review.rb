class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :rating, :user, :video, presence: true
end
