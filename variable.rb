require 'rubygems'
require 'gnuplot'
require_relative 'functions'

class Variable
  attr_accessor :membership_functions, :name, :crisp_input, :range

  def initialize(name)
    @membership_functions = Hash.new
    @name = name
    @range = 0..0
    @crisp_value = 0
  end

  def add_mf(mf)
    @membership_functions[mf.name] = mf

    # extend the range to include the range of the mf
    if mf.range.min < @range.min
      @range = mf.range.min..@range.max
    end
    if mf.range.max > @range.max
      @range = @range.min..mf.range.max
    end

  end

  def crisp_output
    moment = 0.0
    area = 0.0

    @range.step(MembershipFunction::PLOT_STEP) do |x|
      max_mf_value = get_max_mf_value(x)
      area += max_mf_value
      moment += x * max_mf_value

      #puts x.to_s + ' ' + get_max_mf_value(x).to_s
    end

    raise 'Error in COG calculations!' if moment <= 0 or area <= 0

    #puts "MOMENT: #{moment} AREA: #{area}"
    #puts "MOMENT/AREA: #{moment/area}"
    moment / area
  end

  def get_max_mf_value(x)
    max = 0

    @membership_functions.values.each do |mf|
      max = mf.evaluate(x) if mf.evaluate(x) > max
    end

    max
  end

  def plot_sets(plot_to_file=false, plot_cog=false)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.mouse
        plot.view

        plot.yrange '[0:1]'
        plot.title @name
        plot.xlabel 'x'
        plot.ylabel 'y'
        plot.arbitrary_lines << 'set key outside'

        if(plot_to_file)
          plot.terminal "png size 800,600 font 'Helvetica Neue, 11'"
          plot.output "#{@name}.png"
        end

        @membership_functions.values.each do |mf|
          plot.data << mf.get_dataset
        end

        if(plot_cog)
          plot.data << Gnuplot::DataSet.new( [[crisp_output], [0.5]] ) do |ds|
              ds.title = 'crisp output (x-only)'
              ds.with = 'points'
              ds.linecolor = "rgb '#000'"
          end
        end
      end
    end

  end

end
