class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, :category_id, presence: true

  # Class Methods
  def self.search_by_title(search_term)
    # This is case insensative
    Video.where("lower(title) LIKE ?", "%#{search_term.downcase}%")
  end

  # Instance Methods
  def average_rating
    if reviews.any?
      reviews.average(:rating).round(1)
    else
      0
    end
  end
end
