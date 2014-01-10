class Shape
  attr_reader :id, :points
  def initialize(shape = {})
    @id = shape[:id]
    @points = parse(shape[:point])
  end

  def parse(points = [])
    points.map do |point|
      Point.new(point)
    end
  end
end