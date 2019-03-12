require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = []
    10.times do @letters << charset.sample
    end
    @letters = @letters.join(' ')
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    data = JSON.parse(open(url).read)
    @letters = params[:letters].split(' ')
    # puts ruby_data ==> {"found"=>true, "word"=>"lift", "length"=>4}
    letter_hash = Hash.new(0)
    @letters.each { |letter| letter_hash[letter.upcase] += 1 }
    # make a hash with values you can change to check against word
    attempt_hash = Hash.new(0)
    @word.each_char { |letter| attempt_hash[letter.upcase] += 1 }
    # returns a boolean below - save to a var and use for an error message
    allowed = attempt_hash.all? do |letter, times|
      times <= (letter_hash[letter] || 0)
    end

    if allowed == false
      error_message = 1
    elsif data['found'] == false
      error_message = 2
    else
      error_message = 3
    end

    @message = message(error_message)
  end

  def message(error_message)
    if error_message == 1
      message = 'Those letters are not in the grid. You lose.'
    elsif error_message == 2
      message = 'That is not an english word! You lose.'
    else
      message = 'Well Done!'
    end
    return message
  end
end




# def run_game(word, letters, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result
#   url = "https://wagon-dictionary.herokuapp.com/#{word}"
#   data = JSON.parse(open(url).read)
#   error_message = 0
#   letters = letters.split(' ')
#   # puts ruby_data ==> {"found"=>true, "word"=>"lift", "length"=>4}
#   letter_hash = Hash.new(0)
#   letters.each { |letter| letter_hash[letter.upcase] += 1 }
#   # make a hash with values you can change to check against word
#   attempt_hash = Hash.new(0)
#   word.each_char { |letter| attempt_hash[letter.upcase] += 1 }


#   # returns a boolean below - save to a var and use for an error message
#   allowed = attempt_hash.all? do |letter, times|
#     times <= (letter_hash[letter] || 0)
#   end

#   error_message = 1 if allowed == false

#   # attempt_hash.each do |letter_instances|
#   #   error_message = 1 if letter_hash[letter_instances.upcase] < attempt_hash[letter_instances.upcase]
#   # end

#   # attempt_hash.each do |letter_instances|
#   #   error_message = 3 if letter_hash[letter_instances.upcase].zero?
#   # end

#   error_message = 2 if ruby_data["found"] == false

#   length = ruby_data["length"].to_i
#   time = end_time - start_time

#   # puts letter_hash
#   # puts attempt_hash
#   # puts ruby_data["found"]
#   # puts error_message
#   # puts length
#   # puts time
#   # puts score_calculate(length, time, error_message)
#   # puts letter_hash

#   # check to see if all the letters in 'attampt' are in the letters
#   # check to make sure the 'word' is a real word
#   # if either of the above, score is zero and message tells why
#   # else, message is "Well Done!"
#   # build a score that is directly related to ruby_data[length] and inversely related to end_time - start_time

#   result = { time: time, score: score_calculate(length, time.to_i, error_message), message: message(error_message) }
#   return result
# end


# def message(error_message)
#   if error_message == 1
#     message = "Those letters are not in the grid. You lose."
#   elsif error_message == 2
#     message = "That is not an english word! You lose."
#   else
#     message = "Well Done!"
#   end
#   return message
