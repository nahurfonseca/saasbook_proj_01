class Movie < ActiveRecord::Base
  def self.all_ratings
    debugger
    Movie.select(:rating).group(:rating).collect { |m| m.rating }
  end
end
