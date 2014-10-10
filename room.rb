class Room

  attr_reader :short, :long, :name

  def initialize(yml_filename)
    room_data = YAML.load_file('db/rooms/' + yml_filename + '.yml')
    @name = yml_filename
    @short = room_data['short']
    @long = room_data['long']
    @exits = room_data['exits'] || {}
  end

  def exits
    @exits.any? ? 'Exits: ' + @exits.keys.join(', ') + '.' : 'There are no obvious exits.'
  end

  def long_string
    @long + "\n\n" + exits
  end

  def allowed_exit?
    @allowed_exit ||= ->(input) { @exits.keys.include?(input) }
  end

  def []direction
    @exits[direction]
  end
end