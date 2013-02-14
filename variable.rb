require 'rubygems'
require 'gnuplot'
require_relative 'functions'

class Variable
  attr_accessor :membership_functions, :name, :crisp_input, :crisp_output, :range

  def initialize(name)
    @membership_functions = Hash.new
    @name = name
    @range = 0..0
    @crisp_input = nil
    @crisp_output = nil
  end

  def self.create(name, &block)
    variable = Variable.new name
    variable.instance_eval(&block) if block_given?
    variable
  end

  def membership_function(mf)
    @membership_functions[mf.name] = mf

    # extend the range to include the range of the mf
    if mf.range.min < @range.min
      @range = mf.range.min..@range.max
    end
    if mf.range.max > @range.max
      @range = @range.min..mf.range.max
    end

  end

  def compute_crisp_output
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
    @crisp_output = moment / area
  end

  def get_max_mf_value(x)
    max = 0

    @membership_functions.values.each do |mf|
      max = mf.evaluate(x) if mf.evaluate(x) > max
    end

    max
  end

  def plot_sets(opts={})
    { :plot_to_file => false,
      :plot_input => false,
      :plot_output => false }.merge opts

    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.mouse
        plot.view

        plot.yrange '[0:1]'
        plot.title @name
        plot.xlabel 'x'
        plot.ylabel 'y'
        plot.arbitrary_lines << 'set key outside'

        case
          when opts[:plot_to_file]
            plot.terminal "png size 800,600 font 'Helvetica Neue, 11'"
            plot.output "#{@name}.png"
          when opts[:plot_input]
            raise "No crisp input detected - can't plot it!" if @crisp_input.nil?
            plot.arbitrary_lines << "set arrow from #{@crisp_input},0 to #{@crisp_input},1 nohead front"
          when opts[:plot_output]
            raise "No crisp output calculated - can't plot it!" if @crisp_output.nil?
            plot.arbitrary_lines << "set arrow from #{@crisp_output},0 to #{@crisp_output},1 nohead front"
        end

        @membership_functions.values.each do |mf|
          plot.data << mf.get_dataset
        end

      end
    end

  end

end
