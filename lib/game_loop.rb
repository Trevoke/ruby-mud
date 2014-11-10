require_relative 'command_handler'

class GameLoop
  def initialize(user)
    @user = user
    @room = user.saved_room
    @command_handler = CommandHandler.new(@user)
  end

  def call
    display_room
    while (input = get_user_input) != 'quit'
      case input
        # TODO everything should be a command. Take inspiration from pry.
        when @command_handler.ooc_command then @command_handler.send(:ooc, input)
        when @command_handler.who_command then @command_handler.send(:who)
        when @room.allowed_exit? then go(input)
        else output('Sorry, I don\'t understand')
      end
    end
    @user.save_room(@room)
    output('Thanks for playing!')
  end

  private

  def display_room
    output(@room.long_string)
  end

  def go(direction)
    @room = Room.new(@room[direction])
    display_room
  end

  def output(message)
    @user.io.puts(message)
  end

  def get_user_input
    @user.io.gets.chomp
  end
end