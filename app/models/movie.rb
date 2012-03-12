class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.select(:rating).group(:rating).order(:rating).collect { |m| m.rating }
  end
end
