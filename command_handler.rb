class CommandHandler
  def initialize(user)
    @user = user
  end

  def commands
    {
        ooc_command => :ooc,
        who_command => :who
    }
  end

  def who_command
    ->(input) { input[/^who$/] }
  end

  def who
    users_to_display = $logged_on_users.map(&:username).each_slice(6).to_a
    table = Terminal::Table.new(
        title: 'Players currently logged on' ,
        rows: users_to_display
    )
    @user.io.puts table
  end

  def ooc_command
    ->(input) { input[/^ooc /i] }
  end

  def ooc(message)
    clean_message = message.gsub(/^ooc /, '')
    msg = "#{Time.now.strftime('%H:%M:%S')} [OOC] #{@user.username}: #{clean_message}"
    $logged_on_users.each do |user|
      user.io.puts Rainbow(msg).green
    end
  end

end