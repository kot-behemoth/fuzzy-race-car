require 'rubygems'
require 'gnuplot'
require_relative 'functions'

class Variable
  attr_accessor :membership_functions, :name, :crisp_input

  def initialize(name)
    @membership_functions = Hash.new
    @name = name
    @crisp_value = 0
  end

  def plot_sets(plot_to_file=false)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.mouse
        plot.view

        plot.yrange '[0:1]'
        plot.title @name
        plot.xlabel 'x'
        plot.ylabel 'y'

        if(plot_to_file)
          plot.terminal "png size 800,600 font 'Helvetica Neue, 11'"
          plot.output "#{@name}.png"
        end

        @membership_functions.values.each do |fuzzy_set|
          plot.data << fuzzy_set.get_dataset
        end
      end
    end

  end

end
