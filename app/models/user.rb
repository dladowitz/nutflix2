class User < ActiveRecord::Base
  validates :full_name, :email, :password_digest, presence: true
  validates :email, uniqueness: true

  has_many :queue_items
  has_many :reviews

  has_secure_password

  def active_queue_items
    self.queue_items.where(active: true)
  end
end
