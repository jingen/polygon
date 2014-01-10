class Point
  attr_reader :x, :y
  def initialize( point = {x: 0, y: 0} )
    @x = point[:x]
    @y = point[:y]
  end
end