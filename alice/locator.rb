module Alice
  class Locator

    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def object_position
      @object_position ||= Coord.new(self.object.place.coords)
    end

    def current_position
      @current_position ||= Coord.new(Alice::Place.current.coords)
    end

    def locate
      [relative_y, relative_x]
    end

    def relative_x
      return if object_position.x == current_position.x
      return "west" if object_position.x < current_position.x
      return "east"
    end

    def relative_y
      return if object_position.y == current_position.y
      return "north" if object_position.y < current_position.y
      return "south"
    end

    class Coord
      attr_accessor :x, :y
      def initialize(coords)
        self.x, self.y = coords
      end
    end

  end

end