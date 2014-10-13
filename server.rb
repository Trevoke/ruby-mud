require 'bundler'
Bundler.require
require 'gserver'

require_relative 'authenticator'
require_relative 'game_loop'

require 'fileutils'
FileUtils.touch 'db/shadow' unless File.exists? 'db/shadow'
Dir.mkdir('db/player-state') unless Dir.exist?('db/player-state')

$logged_on_users = []

class Mud < GServer
  def initialize(port=5309, *args)
    super(port, *args)
  end

  def serve(io)
    user = login_user(io)
    disconnect_bad_user(io) && return unless user.authenticated?
    play_game(user)
  rescue NoMethodError => e # People who disconnect without quitting
    $logged_on_users.delete(user)
  rescue Exception => e # Until I have a better idea
    puts "User #{user.username} ran into this trouble:"
    puts e
  end

  def login_user(io)
    Authenticator.new(io).call
  end

  def play_game(user)
    $logged_on_users << user
    GameLoop.new(user).call
    $logged_on_users.delete(user)
  end

  def disconnect_bad_user(io)
    io.puts 'Try again soon!'
  end

end

mud = Mud.new(5309)
mud.audit = true

mud.start
mud.join
