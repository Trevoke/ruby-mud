require 'bundler'
Bundler.require
require 'gserver'

require_relative 'authenticator'
require_relative 'game_loop'

class Mud < GServer
  def initialize(port=5309, *args)
    super(port, *args)
  end

  def serve(io)
    user = login_user(io)
    io.puts 'We hope you try again soon' && return unless user.authenticated?
    play_game(user)
  rescue Exception => e
    puts "User #{user} ran into this trouble:"
    puts e
  end

  def login_user(io)
    Authenticator.new(io).call
  end

  def play_game(user)
    GameLoop.new(user).call
  end
end

mud = Mud.new(5309)

require 'fileutils'
FileUtils.touch 'db/shadow' unless File.exists? 'db/shadow'

mud.start
mud.join
