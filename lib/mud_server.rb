require 'bundler'
Bundler.require
require 'gserver'
require 'fileutils'

require_relative 'shadow'
require_relative 'authenticator'
require_relative 'game_loop'

$logged_on_users = [] # TODO handle "chat" as a permanent group
# TODO set up group chats as commands

class MudServer < GServer

  ROOT = File.dirname(File.expand_path(File.join(__FILE__, '..')))

  def initialize(port=5309, *args)
    ensure_directories_exist
    @shadow_file = Shadow.new(@shadow)
    super(port, *args)
  end

  def serve(io)
    user = login_user(io, @shadow_file)
    disconnect_bad_user(io) && return unless user.authenticated?
    play_game(user)
  rescue NoMethodError => e # People who disconnect without quitting
    $logged_on_users.delete(user)
  rescue Exception => e # TODO log this instead
    puts "User #{user.username} ran into this trouble:"
    puts e
  end

  def login_user(io, shadow_file)
    Authenticator.new(io, shadow_file).call
  end

  def play_game(user)
    $logged_on_users << user
    GameLoop.new(user).call
    $logged_on_users.delete(user)
  end

  def disconnect_bad_user(io)
    io.puts 'Try again soon!'
  end

  private

  def ensure_directories_exist
    @db_dir = File.join(ROOT, 'db')
    Dir.mkdir(@db_dir) unless Dir.exist?(@db_dir)

    @player_state_dir = File.join(@db_dir, 'player-state')
    Dir.mkdir(@player_state_dir) unless Dir.exist?(@player_state_dir)

    @shadow = File.join(@db_dir, 'shadow')
    FileUtils.touch @shadow unless File.exists? @shadow
  end

end
