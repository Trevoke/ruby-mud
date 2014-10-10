class GameLoop
  def initialize(user)
    @user = user
    @room = user.saved_room
  end

  def call
    display_room
    while (input = get_user_input) != 'quit'
      case input
        when /^('|say )/ then speak(input)
        when @room.allowed_exit? then go(input)
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

  def speak(message)
    output(message.sub(/^('|say )/, ''))
  end

  def output(message)
    @user.io.puts(message)
  end

  def get_user_input
    @user.io.gets.chomp
  end
end