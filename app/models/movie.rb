class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.group(:rating).all.collect { |m| m.rating }
  end
end
