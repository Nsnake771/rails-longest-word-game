require "open-uri"
class GamesController < ApplicationController
  VOWELS     = %w(A E I O U Y)
  CONSONANTS = (('A'..'Z').to_a - VOWELS)

  def new
    @letters  = VOWELS.sample(5)     # 5 voyelles distinctes
    @letters += CONSONANTS.sample(5) # 5 consonnes distinctes
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @guess = (params[:guess] || "").upcase
    @included = included?(@guess, @letters)
    @english_word = english_word?(@guess)
  end

  private

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?(guess)
    response = URI.open("https://dictionary.lewagon.com/#{guess}")
    json = JSON.parse(response.read)
    json['found']
  end
end
