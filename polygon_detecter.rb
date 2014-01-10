#!/usr/bin/ruby

require "test/unit"
require "json"
require_relative "point"
require_relative "shape"

class PolygonDetecter < Test::Unit::TestCase
  def gen_json(filename)
    JSON.parse(File.new(filename, 'r').read, symbolize_names: true)
  end

  def test_main
    puts "\n--------------------- The following is the result: -----------------------\n"
    input_data = ARGV[0].nil? ? "shapes.dat" : ARGV[0]
    shapes = gen_json(input_data)

    ps = shapes[:geometry][:shape][0]
    puts ps
    pts = Shape.new(ps).points
    pts.each do |pt|
      p pt
    end


  end
end