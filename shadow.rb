require 'bcrypt'

class Shadow
  DB = './db/shadow'

  PARSING_OPTIONS = {
      col_sep: ':'
  }

  def self.username_available?(username)
    !username_exists?(username)
  end

  def self.username_exists?(username)
    in_shadow_file.any? do |row|
      row[0] == username
    end
  end

  def self.password_for(username)
    account_info = in_shadow_file.find { |row| row[0] == username }
    BCrypt::Password.new(account_info[1])
  end

  def self.in_shadow_file
    CSV.foreach(DB, PARSING_OPTIONS)
  end

  def self.create!(username, password)
    CSV.open(DB, 'a', PARSING_OPTIONS) do |csv|
      csv << [username, BCrypt::Password.create(password)]
    end
  end

end