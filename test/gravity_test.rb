require 'minitest/autorun'
require 'active_support/inflector'

class MudObject
  attr_accessor :name, :description
end

class Item < MudObject
  attr_accessor :weight
end

class Cutlass < Item
  def initialize
    @name = 'a cutlass'
    @description = 'a sharp, piratey sword'
    @weight = 2.8
  end
end

class Command < MudObject

end

class SpawnItem < Command
  def self.call(object)
    case object
      when Symbol
        object.to_s.classify.constantize.new
      else
        object
    end

  end
end

class AddItem < Command
  def self.call(location, object)
    location.add_item(SpawnItem.call(object))
  end
end

class Room < MudObject
  attr_accessor :items_on_ground, :floating_items
  def initialize
    @items_on_ground = []
    @floating_items = []
  end

  def add_item(item)
    if item.weight <= 0
      floating_items << item
    else
      items_on_ground << item
    end
  end
end

class TestRoom < Room

end


class GravityTest < MiniTest::Test



  def test_room_has_gravity_source
    room = TestRoom.new
    cutlass = SpawnItem.call(:cutlass)
    AddItem.call(room, cutlass)
    assert_equal [cutlass], room.items_on_ground
  end
end