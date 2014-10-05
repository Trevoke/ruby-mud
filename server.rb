require 'bundler'
Bundler.require
require 'gserver'
require_relative 'authenticator'

class Mud < GServer
  def initialize(port=5309, *args)
    super(port, *args)
  end

  def serve(io)
    user = login_user(io)
    return unless user.authenticated?
    play_game(io)
    rescue Exception => e
      puts e
      exit 1
  end

  def login_user(io)
    user = Authenticator.new(io).call
  end

  def play_game(io)
    io.puts 'You win!'
  end
end

mud = Mud.new(5309)

mud.start
mud.join