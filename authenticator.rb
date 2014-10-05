require_relative 'user'
require 'csv'

SHADOW_FILE = 'db/shadow'

class Authenticator

  def initialize(io)
    @io = io
  end

  def call
    user_input = ''
    loop do
      @io.puts 'Enter your username, or type "new" to register a new account:'
      user_input = @io.gets.chomp
      break if user_input.downcase == 'new' || username_exists?(user_input)
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
      break if username_available?(username)
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
    account_password = password_for(username)
    password = ''
    3.times do
      @io.puts 'Enter your password:'
      password = @io.gets.chomp
      break if account_password == password
    end
    if account_password == password
      User.new(@io, username)
    else
      InvalidUser.new(@io)
    end
  end

  def username_available?(username)
    CSV.foreach(SHADOW_FILE, col_sep: ':').none? do |row|
      row[0] == username
    end
  end

  def username_exists?(username)
    CSV.foreach(SHADOW_FILE, col_sep: ':').any? do |row|
      row[0] == username
    end
  end

  def password_for(username)
    account_info = CSV.foreach(SHADOW_FILE, col_sep: ':').find { |row| row[0] == username }
    BCrypt::Password.new(account_info[1])
  end
end