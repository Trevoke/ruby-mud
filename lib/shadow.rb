require 'bcrypt'

class Shadow

  PARSING_OPTIONS = {
      col_sep: ':'
  }

  def initialize(file)
    @db = file
  end

  def username_available?(username)
    !username_exists?(username)
  end

  def username_exists?(username)
    in_shadow_file.any? do |row|
      row[0] == username
    end
  end

  def password_for(username)
    account_info = in_shadow_file.find { |row| row[0] == username }
    BCrypt::Password.new(account_info[1])
  end

  def in_shadow_file
    CSV.foreach(@db, PARSING_OPTIONS)
  end

  def create!(username, password)
    CSV.open(@db, 'a', PARSING_OPTIONS) do |csv|
      csv << [username, BCrypt::Password.create(password)]
    end
  end

end