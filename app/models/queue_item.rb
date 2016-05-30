class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, :video, presence: true

  before_create :set_position

  private

  def set_position
    self.position = user.queue_items.count + 1
  end
end
