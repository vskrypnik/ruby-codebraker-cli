require 'codebreaker'

require './source/utility/output'

class Application

  def initialize
    @game = Codebreaker::Game.new
    @game.start
  end

  def run
    Output.welcome

    until @game.finish?
      play
      save?
      again?
    end
  end

  private

  def play
    until @game.finish?
      print '> '

      output = process gets.chomp.downcase
      puts output if output.is_a? String
    end
  end

  def process(input)
    case input
      when /^[1-6]+$/ then
        check input
      when 'exit' then
        exit
      when 'hint' then
        hint
      else
        Output.help
    end
  end

  def check(value)
    result = @game.check value

    if result.is_a? String
      return "Result: #{result}"
    end

    case result
      when :WIN then
        'Congratulations! You win!'
      when :LOSE then
        'So sorry... You lose.'
    end
  end

  def hint
    (hint = @game.hint) ?
      "The number contains digit: #{hint}." :
      "All available hints have already been used!"
  end

  def save?
    print 'Do you want to save the score? (y/n): '
    result = %w(yes y).include? gets.chomp.downcase

    if result
      print 'Enter your nickname: '
      nickname = gets.chomp.strip

      unless nickname.empty?
        hash = hashcode nickname
        @game.write nickname, hash
      end
    end
  end

  def again?
    print 'Do you want to play again? (y/n): '
    result = %w(yes y).include? gets.chomp.downcase
    @game.start if result
  end

  def hashcode(nickname)
    Digest::MD5.hexdigest nickname.to_s
  end
end
