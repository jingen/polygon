class Shape
  attr_reader :id, :points
  def initialize(shape = {})
    @id = shape[:id] unless shape[:id].nil?
    @points = parse(shape[:point]) unless shape[:point].nil?
  end

  def zcrossproduct(point1, point2, point3)
    dx1 = point2.x - point1.x
    dy1 = point2.y - point1.y
    dx2 = point3.x - point2.x
    dy2 = point3.y - point2.y
    dx1*dy2 -dy1*dx2
  end

  def is_polygon
    @is_polygon ||= check_polygon
  end

  def check_polygon
    return false if @points.length < 3
    zpoints = Array.new(@points)
    zpoints += [@points[0], @points[1]]
    side_prev = zcrossproduct(zpoints[0], zpoints[1], zpoints[2])
    for i in 1...(zpoints.length-2)
      side_next = zcrossproduct(zpoints[i], zpoints[i+1], zpoints[i+2])
      return false if (side_prev * side_next < 0)
    end
    return true
  end

  def point_is_inside(point)
    result = false
    vertex1 = @points.length - 1
    for vertex2 in 0...@points.length
      if ((@points[vertex2].y > point.y) != (@points[vertex1].y >= point.y)) && (point.x <= (points[vertex1].x - points[vertex2].x) * (point.y - points[vertex2].y) / (points[vertex1].y - points[vertex2].y) + points[vertex2].x)
        result = !result
      end
      vertex1 = vertex2
      vertex2 += 1
    end
    return result
  end

  def surrounds(shape)
    shape.points.each do |point|
      return false unless point_is_inside(point)
    end
    return true
  end

  def is_inside(shape)
    shape.surrounds(self)
  end

  def segments_intersection(a, b, c, d)
    denominator = (b.y - a.y)*(d.x - c.x) - (a.x - b.x)*(c.y - d.y) 
    return false if denominator == 0
    x = ( (b.x - a.x) * (d.x - c.x) * (c.y - a.y) + (b.y - a.y) * (d.x - c.x) * a.x - (d.y - c.y) * (b.x - a.x) * c.x ) / denominator
    y = -( (b.y - a.y) * (d.y - c.y) * (c.x - a.x) + (b.x - a.x) * (d.y - c.y) * a.y - (d.x - c.x) * (b.y - a.y) * c.y ) / denominator
    if (x - a.x) * (x - b.x) <= 0 && (y - a.y) * (y - b.y) <= 0 && (x - c.x) * (x - d.x) <= 0 && (y - c.y) * (y - d.y) <= 0  
      return true
    else
      return false
    end
  end

  def intersects(shape)
    p1 = shape.points.length - 1
    for p2 in 0...shape.points.length
      p3 = @points.length - 1
      for p4 in 0...@points.length
        return true if segments_intersection(shape.points[p1], shape.points[p2], @points[p3], @points[p4])
        p3 = p4
        p4 += 1
      end
      p1 = p2
      p2 += 1
    end
    return false
  end

  def is_separate(shape)
    !surrounds(shape) && !is_inside(shape) && !intersects(shape)
  end

  def get_relation(shape)
    if surrounds(shape)
      return "surrounds"
    elsif is_inside(shape)
      return "is inside"
    elsif intersects(shape)
      return "intersects"
    else
      return "is separate from"
    end
  end

  private
  def parse(points = [])
    points.map do |point|
      Point.new(point)
    end
  end
end