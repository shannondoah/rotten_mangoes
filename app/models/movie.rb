class Movie < ActiveRecord::Base
  
  has_many :reviews

  scope :check, ->(params) { where("director like ? OR title like ?", ["%#{params}%"], ["%#{params}%"] ) }

  mount_uploader :poster, PosterUploader

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size unless reviews.size < 1 
  end

  def self.duration(runtime)
    case runtime
    when "Under 90 Minutes"
      self.where("runtime_in_minutes < ?", 90)
    when "Over 120 Minutes"
      self.where("runtime_in_minutes > ?", 120)
    when "Between 90 and 120 Minutes"
      self.where("runtime_in_minutes >= ? AND runtime_in_minutes <= ? ", 90, 120)
    else
      self.all
    end
  end

  def self.search(search)
    if search
      self.check(search[:td]).duration(search[:runtime_in_minutes].to_s)
    else
      self.all
    end
  end


  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
