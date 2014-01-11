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

  def gen_relations(shapes)
    @relations = Hash.new
    shapes.each do |shape1|
      @relations[shape1.id] = Array.new
      shapes.each do |shape2|
        if shape1 != shape2
          @relations[shape1.id] << {shape2.id => shape1.get_relation(shape2)}
        end
      end
    end
  end

  def printout_invalid_errors
    @non_convex_polygons.each do |shape|
      puts "\"#{shape.id}\" is not a polygon"
    end
  end

  def printout_relations
    @relations.each do |shape, relations|
      relations.each do |relation|
        relation.each do |key, value|
          puts "\"#{shape}\" #{value} \"#{key}\""
        end
      end
    end
  end

  def test_main
    puts "\n--------------------- The following is the result: -----------------------\n\n"
    @shapes = gen_shapes
    @convex_polygons = Array.new
    @non_convex_polygons = Array.new
    @shapes.each do |shape|
      if shape.is_polygon
        @convex_polygons << shape
      else
        @non_convex_polygons << shape
      end
    end

    gen_relations(@convex_polygons)
    printout_invalid_errors
    printout_relations

    puts "\n--------------------------------- end ------------------------------------\n"
  end
end
