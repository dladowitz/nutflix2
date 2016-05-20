class User < ActiveRecord::Base
  validates :full_name, :email, :password, presence: true
  validates :email, uniqueness: true

  has_secure_password
end
