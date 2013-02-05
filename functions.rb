class MembershipFunction
  PLOT_STEP = 0.1

  def evaluate(x)
  end
 
  def get_dataset
  end

end

class Trapezoid < MembershipFunction
  attr_accessor :lmin, :lmax, :rmax, :rmin

  def initialize(lmin, lmax, rmax, rmin)
    @lmin = lmin
    @lmax = lmax
    @rmax = rmax
    @rmin = rmin
  end

  def evaluate(x)
    case x
      when @lmin...@lmax
        (x-@lmin) / (@lmax-@lmin)
      when @lmax...@rmax
        1
      when @rmax..@rmin
        1 - (x-@rmax) / (@rmin-@rmax)
      else
        0
    end
  end
 
  def get_dataset
    xs = Array.new
    ys = Array.new
    mf_range = @lmin..@rmin
    mf_range.step(PLOT_STEP) do |x|
      xs << x
      ys << evaluate(x)
    end

    Gnuplot::DataSet.new( [xs, ys] ) do |ds|
      ds.notitle
      ds.with = 'filledcurve'
      ds.linewidth = 1
    end
  end

end

class Triangle < MembershipFunction
  attr_accessor :lmin, :max, :rmin

  def initialize(lmin, max, rmin)
    @lmin = lmin
    @max = max
    @rmin = rmin
  end

  def evaluate(x)
    case x
      when @lmin...@max
        (x-@lmin) / (@max-@lmin)
      when @max..@rmin
        1 - (x-@max) / (@rmin-@max)
      else
        0
    end
  end

  def get_dataset
    xs = Array.new
    ys = Array.new
    mf_range = @lmin..@rmin
    mf_range.step(PLOT_STEP) do |x|
      xs << x
      ys << evaluate(x)
    end

    Gnuplot::DataSet.new( [xs, ys] ) do |ds|
      ds.notitle
      ds.with = 'filledcurve'
      ds.linewidth = 1
    end
  end

end
