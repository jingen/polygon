#!/usr/bin/env ruby

require "test/unit"
require "json"
require_relative "point"
require_relative "shape"

class PolygonDetecter < Test::Unit::TestCase
  def gen_json(filename)
    JSON.parse(File.new(filename, 'r').read, symbolize_names: true)
  end

  def gen_shapes
    input_file = ARGV[0].nil? ? "example.dat" : ARGV[0]
    shapes_json = gen_json(input_file)
    shapes_json[:geometry][:shape].map do |shape_json|
      Shape.new(shape_json)
    end
  end

  def test_main
    puts "\n--------------------- The following is the result: -----------------------\n"
    shapes = gen_shapes
    pp shapes


  end
end