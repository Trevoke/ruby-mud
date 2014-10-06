require_relative 'shadow'
require_relative 'user'
require 'csv'

class Authenticator

  def initialize(io)
    @io = io
  end

  def call
    user_input = ''
    loop do
      @io.puts 'Enter your username, or type "new" to register a new account:'
      user_input = @io.gets.chomp
      break if user_input.downcase == 'new' || Shadow.username_exists?(user_input)
      @io.puts 'Username does not exist, please try again.'
    end
    if user_input.downcase == 'new'
      register_new_user
    else
      login_user(user_input)
    end
  end

  def register_new_user
    username = password = ''
    loop do
      @io.puts 'Enter the name by which you wish to be known here:'
      username = @io.gets.chomp
      break if Shadow.username_available?(username)
      @io.puts 'Username not available.'
    end
    loop do
      @io.puts 'Enter your password:'
      password = @io.gets.chomp
      @io.puts 'Enter your password again:'
      password_confirmation = @io.gets.chomp
      break if password == password_confirmation
      @io.puts 'Passwords do not match.'
    end
    User.create(@io, username, password)
  end

  def login_user(username)
    account_password = Shadow.password_for(username)
    password = ''
    3.times do
      @io.puts 'Enter your password:'
      password = @io.gets.chomp
      break if account_password == password
    end
    if account_password == password
      User.new(@io, username)
    else
      InvalidUser.new
    end
  end

end