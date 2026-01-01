require 'pry-byebug'
class Mastermind
  COLORS = %w[green blue red yellow orange pink]

  def play_game # rubocop:disable Metrics/MethodLength
    @hum_score = 0
    @comp_score = 0
    puts 'Heads up, These are the only valid options you can pick: '
    puts "('green','blue','red','yellow','orange','pink')"
    puts 'Any other input will be declined \n'

    print 'how many rounds do you want to play?:'
    @rounds = 2 * gets.chomp.to_i
    print 'Who do you want to start as?(codebreaker/default:codemaster): '
    start = gets.chomp.downcase.strip.eql? 'codebreaker'
    @turn = start ? 'human' : 'computer'

    rounds.times do
      @out_of_tries = true
      puts "#{turn} as code breaker"
      @code = []
      if turn.eql? 'computer'
        enter_colors code
      else
        4.times { @code.push COLORS.sample }
      end
      p code
      12.times do
        guess = []
        if turn.eql? "human"
          enter_colors guess
        else
          comp_guess guess
        end

        if guess.eql? code
          win_game
          break
        else
          puts 'Nah,keep on guessing .take this feedback'
          give_feedback guess
        end
      end
      puts "Uh-Oh,You're out of Tries opponent wins\n" if out_of_tries
      human_played = turn.eql? 'human'
      @turn = human_played ? 'computer' : 'human'
    end

    who_won?
    print 'Wanna, Play again?(yes/default:no): '
    play_again = gets.chomp.strip.downcase.eql? 'yes'
    play_game if play_again
  end

  private

  attr_accessor :turn, :comp_score, :hum_score, :rounds, :code, :out_of_tries

  def give_feedback(guess)
    correct_placed = 0
    wrong_placed = 0
    master_code = code - []

    guess.each_with_index do |color, index|
      if color.eql? master_code[index]
        correct_placed += 1
        master_code[index] = 'considered'
      elsif master_code.include? color
        wrong_placed += 1
        master_code[master_code.index(color)] = 'considered'
      end
      p master_code
    end

    puts "Correctly Placed: #{correct_placed}"
    puts "Wrongly Placed: #{wrong_placed}\n"
  end

  def enter_colors(guess) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    puts 'Type your guesses'
    4.times do |index|
      print "Color #{index + 1}:"
      color_typed = gets.chomp.strip.downcase

      until COLORS.include? color_typed
        puts 'This time try valid values bozo :)'
        print "Color #{index + 1}:"
        color_typed = gets.chomp.downcase.strip
      end

      guess.push color_typed
    end
  end

  def comp_guess(guess)
    4.times { guess.push COLORS.sample }
  end

  def win_game
    puts 'You guessed correct! hurray'
    @out_of_tries = false
    player_human = turn.eql? 'human'
    player_human ? (@hum_score = hum_score + 1) : (@comp_score = comp_score + 1)
  end

  def who_won?
    if hum_score > comp_score
      puts "Human Won"
    elsif comp_score > hum_score
      puts "Computer Won"
    else
      puts "Looks like there are no rounds or a tie"
    end
  end
  
end
