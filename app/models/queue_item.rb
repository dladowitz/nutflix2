# TODO Figure out where this goes
class PositionValidator < ActiveModel::Validator
  def validate(record)
    if record.user && record.active
      active_items = record.user.active_queue_items.to_a
      active_items.delete(record) if active_items.include? record

      active_positions = active_items.map{|item| item.position}
      if active_positions.include? record.position
        record.errors[:position] << "needs to be unique across a user."
      end
    end
  end
end


class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user, :video, presence: true
  validates_with PositionValidator

  before_create :set_position

  # This is used for deactivating a queue_item.
  # TODO create a deactive method
  before_update :reorder_queue_on_deactivation, if: :active_changed?

  def inactive
    self.active == false
  end

  # TODO create test
  def current_rating
    last_review ? last_review.rating : nil
  end

  def last_review
    video.reviews.where("user_id = #{user.id}").order(:created_at).last
  end

  def update_or_create_review(new_rating)
    if new_rating == "0"
      return
    elsif last_review
      last_review.update_attributes(rating: new_rating)
    else
      user.reviews.create(rating: new_rating, video: video)
    end
  end


  private

  def set_position
    self.position = user.queue_items.count + 1
  end

  def reorder_queue_on_deactivation
    if self.active == false
      position = self.position
      last_items = user.queue_items.drop(position)

      last_items.each do |item|

        #update_attribute doesn't call validations. Validation was causing infinite loop.
        item.update_attribute(:position, item.position - 1)
      end
    end
  end
end
