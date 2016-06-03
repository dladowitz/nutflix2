class User < ActiveRecord::Base
  validates :full_name, :email, :password_digest, presence: true
  validates :email, uniqueness: true

  has_many :queue_items
  has_many :reviews

  has_secure_password

  def active_queue_items
    self.queue_items.where(active: true).order(:position)
  end

  def has_video_in_queue?(video)
    videos_in_queue = queue_items.map(&:video)
    videos_in_queue.include? video
  end
end
