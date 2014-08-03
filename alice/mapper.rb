class Mapper

  def create
    content = ::Place.all.map do |place|
      room(place.x, place.y, place.is_current, place.describe, place.exits)
    end
    write_file(content)
    save_to_cloud
  end

  def path_to_file
    "images/map.svg"
  end

  def write_file(content)
    File.open(path_to_file, "w+") do |file|
      file.puts document(content)
    end
  end

  def save_to_cloud
    url = Alice::AWS.new.upload(path_to_file)
    puts url
  end

  def room(x, y, is_current, desc, exits=[])
    grid_size = 100
    room_size = grid_size - 5
    abs_x = (origin[:x] + x) * grid_size + 25
    abs_y = (origin[:y] + y) * grid_size + 25
    lines = []
    lines << %{<rect x="#{abs_x}" y="#{abs_y}" }
    lines << %{stroke="red" stroke-width="3" } if is_current
    lines << %{width="#{room_size}" height="#{room_size}" rx="5" ry="5"> }
    lines << %{<title>#{Alice::Util::Sanitizer.process(desc)}</title> }
    lines << %{</rect>}
    exits.each do |exit|
      case exit
      when "north"
        door_x = abs_x + (room_size -20) / 2
        door_y = abs_y + 2 - 10
      when "east"
        door_x = abs_x + room_size + 2 - 10
        door_y = abs_y + (room_size - 20) / 2
      when "south"
        door_x = abs_x + (room_size -20) / 2
        door_y = abs_y + room_size + 2 - 10
      when "west"
        door_x = abs_x - 10
        door_y = abs_y + (room_size - 20) / 2
      end
      lines << %{<rect x="#{door_x}" y="#{door_y}" width="20" height="20" />}
    end
    lines.join("")
  end

  private

  def origin
    @origin ||= {
      x: Place.min(:x).abs,
      y: Place.min(:y).abs
    }
  end

  def height
    calculated = (Place.min(:y).abs + Place.max(:y).abs) * 100 + 250
    calculated > 100 ? calculated : 100
  end

  def width
    calculated = (Place.min(:x).abs + Place.max(:x).abs) * 100 + 250
    calculated > 100 ? calculated : 100
  end

  def document(content)
    lines = []
    lines << %{<?xml version="1.0" standalone="no"?>}
    lines << %{<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">}
    lines << %{<svg width="#{width}" height="#{height}" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">}
    lines << %{<defs>}
    lines << %{<filter color-interpolation-filters='sRGB' id='filter3001'>}
    lines << %{<feTurbulence type='fractalNoise' baseFrequency='100 .85' numOctaves='1'/>}
    lines << %{</filter>}
    lines << %{</defs>}
    lines << %{<rect height='200%' width='200%' style='filter:url(#filter3001)' />}
    lines << %{<rect height='200%' width='200%' style='fill:#c4c452;fill-opacity:0.25;'/>}
    lines << content
    lines << %{</svg>}
    lines.join("\r\n")
  end

end
