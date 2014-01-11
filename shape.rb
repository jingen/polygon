class Shape
  attr_reader :id, :points
  def initialize(shape = {})
    @id = shape[:id] unless shape[:id].nil?
    @points = parse(shape[:point]) unless shape[:point].nil?
  end

  def isLeft
    
  end
  
  private
  def parse(points = [])
    points.map do |point|
      Point.new(point)
    end
  end
end