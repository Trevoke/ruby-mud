require 'bcrypt'

class Account
  def initialize(io)
    @io = io
  end
end

class InvalidUser < Account
  def authenticated?
    false
  end
end

class User < Account

  def self.create(io, username, password)
    CSV.open(SHADOW_FILE, 'a', col_sep: ':') do |csv|
      csv << [username, BCrypt::Password.create(password)]
    end
    self.new(io, username)
  end

  def initialize(io, username)
    @username = username
    super(io)
  end

  def authenticated?
    true
  end
end