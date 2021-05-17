require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = (params[:word] || "").upcase
    @letters = params[:letters].split
    @english_word = english_word?(@word)
    @included = included?(@letters, @word)
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(letters, word)
    word.chars.all? do |letter|
      letters.include?(letter)
    end
  end
end
