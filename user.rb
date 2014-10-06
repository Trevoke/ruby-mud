require 'bcrypt'

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
end