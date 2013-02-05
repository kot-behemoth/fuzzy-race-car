class MembershipFunction

  def evaluate(x)
  end
 
  def get_dataset
  end

end

class Triangle < MembershipFunction
  attr_accessor :lmin, :max, :rmin, :plot_step

  def initialize(lmin, max, rmin)
    @lmin = lmin
    @max = max
    @rmin = rmin
    @plot_step = 0.1
  end

  def evaluate(x)
    case x
      when x < @lmin
        return 0
      when @lmin...@max
        (x-@lmin) / (@max-@lmin)
      when @max...@rmin
        1 - (x-@max) / (@rmin-@max)
      else #when x >= @rmin
        0
      #else
        #raise "Wrong range in evaluate for x value #{x}"
    end
  end

  def get_dataset
    xs = Array.new
    ys = Array.new
    mf_range = @lmin..@rmin
    mf_range.step(@plot_step) do |x|
      xs << x
      ys << evaluate(x)
    end

    Gnuplot::DataSet.new( [xs, ys] ) do |ds|
      ds.notitle
      ds.with = 'filledcurve'
      ds.linewidth = 1
      # colour = ColorMath::HSL.new(337, 64, 0.56).hex
      # ds.linecolor = "rgb '#{colour}'"
    end
  end

end
