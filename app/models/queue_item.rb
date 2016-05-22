class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, :video, :position, presence: true
end
