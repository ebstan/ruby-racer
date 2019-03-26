# fixed board layout + N square long
# 2 players or more
# EXTRA (Graphic) : ASCII art + Player's symbol color
# EXTRA (Features): Powerups + Landmines + Player + Control

require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30) 
    @players = {}
    # player's position
    players.each do |player|
      @players[player] = 1
    end
    @length = length
    @die = Die.new
  end

  def reputs(str = '')
    puts "\e[0K" + str
  end

  # Returns +true+ if one of the players has reached the finish line, +false+ otherwise
  def finished?
    if @players.has_value?(@length)
      return true
    end
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @players.key(@players.values.max)
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    steps = @die.roll 
    @players[player] += steps
    if @players[player] > @length
      @players[player] = @length
    end
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    reputs
    @players.each do |player, position|
      puts ("| " * position) + player + (" |" * (@length + 1 - position))
      # puts ("| " * position) + player.colorize(:red) + (" |" * (@length + 1 - position))
    end 
  end
end

players = ['a', 'b', 'c']

game = RubyRacer.new(players)

# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
  players.each do |player|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.advance_player!(player)
    game.print_board

    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.5)

  end
end

puts "Player '#{game.winner}' has won!"
