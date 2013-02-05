require 'rubygems'
require 'gnuplot'
require_relative 'functions'

class Variable
  attr_accessor :fuzzy_sets, :name

  def initialize(name)
    @fuzzy_sets = Hash.new
  end

  def plot_sets()
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |p|
        p.mouse
        p.view

        #p.xrange "[-10:10]"
        p.title  name
        p.xlabel 'x'
        p.ylabel 'y'

        @fuzzy_sets.values.each do |fuzzy_set|
          p.data << fuzzy_set.get_dataset
        end
      end
    end

  end

end
