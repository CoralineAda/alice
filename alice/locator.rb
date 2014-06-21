module Alice
  class Locator

    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def object_place
      if owner = object.owner
        Place.current
      else
        object.place
      end
    end

    def object_position
      return unless object_place
      @object_position ||= Coord.new(self.object_place.coords)
    end

    def current_position
      @current_position ||= Coord.new(Place.current.coords)
    end

    def locate
      [relative_y, relative_x]
    end

    def relative_x
      return "Nowhere" unless object_position
      return "there" if object_position.x == current_position.x
      return "west" if object_position.x < current_position.x
      return "east"
    end

    def relative_y
      return unless object_position
      return "here" if object_position.y == current_position.y
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