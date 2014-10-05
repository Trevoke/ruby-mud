class Shadow
  DB = './db/shadow'

  PARSING_OPTIONS = {
      col_sep: ':'
  }

  def self.username_available?(username)
    !username_exists?(username)
  end

  def self.username_exists?(username)
    CSV.foreach(DB, PARSING_OPTIONS).any? do |row|
      row[0] == username
    end
  end

  def self.password_for(username)
    account_info = CSV.foreach(DB, PARSING_OPTIONS).find { |row| row[0] == username }
    BCrypt::Password.new(account_info[1])
  end

  def self.create!(username, password)
    CSV.open(DB, 'a', PARSING_OPTIONS) do |csv|
      csv << [username, BCrypt::Password.create(password)]
    end
  end

end