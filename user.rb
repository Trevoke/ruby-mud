require 'bcrypt'
require 'fileutils'
require 'yaml'
require_relative 'room'

class InvalidUser
  def authenticated?
    false
  end
end

class User
  attr_reader :username, :io
  def self.create(io, username, password)
    Shadow.create!(username, password)
    self.new(io, username)
  end

  def initialize(io, username)
    @username = username
    @io = io
  end

  def authenticated?
    true
  end

  def saved_room
    Room.new(saved_state[:saved_room])
  end

  def save_room(room)
    File.open(state_file_name, 'w') do |f|
      f << YAML.dump(saved_room: room.name)
    end
  end

  def saved_state
    @saved_state ||= load_or_initialize_state_file
  end

  def load_or_initialize_state_file
    create_state_file(state_file_name) unless File.exists?(state_file_name)
    YAML.load_file(state_file_name)
  end

  def state_file_name
    @filename ||= "db/player-state/#{username}"
  end

  def create_state_file(filename)
    File.open(filename, 'w') do |f|
      f << YAML.dump(saved_room: 'start')
    end
  end
end