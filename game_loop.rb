class GameLoop
  def initialize(user)
    @user = user
  end

  def call
    while (input = get_user_input) != 'quit'
      case input
        when /^('|say )/ then speak(input)
      end
    end
  end

  private

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