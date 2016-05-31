class PositionValidator < ActiveModel::Validator
  def validate(record)
    unless record.position == 1
      record.errors[:position] << 'Needs to be 1 and only 1!'
    end
  end
end


class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, :video, presence: true
  validates :position, uniqueness: { scope: :user }
  # validates_with PositionValidator

  before_create :set_position
  before_update :reorder_queue_positions, if: :active_changed?

  private

  def set_position
    self.position = user.queue_items.count + 1
  end

  def reorder_queue_positions
    if self.active == false
      position = self.position
      last_items = user.queue_items.drop(position)

      last_items.each do |item|
        item.update_attributes(position: item.position - 1)
      end
    end
  end
end
