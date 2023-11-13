require "open-uri"
require "json"

class GamesController < ApplicationController

  def new
    @letters = [*("a".."z")].sample(10)
  end

  def score
    grid = params[:grid]
    attempt = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    words_serialized = URI.open(url).read
    words = JSON.parse(words_serialized)
    @result = ""

    if !overuse?(attempt, grid)
      @result = "Sorry but <strong>#{attempt.upcase}</strong> can't be built out of #{grid.gsub(" ", "").upcase.chars.join(", ")}"
    elsif words["found"]
      @result = "Congratulations! <strong>#{attempt.upcase}</strong> is a valid English word!"
    else
      @result = "Sorry but <strong>#{attempt.upcase}</strong> does not seem to be a valid English word..."
    end
  end

  def overuse?(attempt, grid)
    attempt.chars.each do |char|
      overuse_attempt = attempt.count(char)
      overuse_grid = grid.count(char)
      return false if overuse_attempt > overuse_grid
    end
    return true
  end

end
