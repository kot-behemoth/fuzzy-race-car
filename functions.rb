require_relative 'utils'

class MembershipFunction
  PLOT_STEP = 0.1

  def evaluate(x)
  end
 
  def get_dataset
  end

end

class Trapezoid < MembershipFunction
  attr_accessor :max_y
  attr_reader :lmin, :lmax, :rmax, :rmin, :name

  def initialize(name, lmin, lmax, rmax, rmin)
    raise 'Wrongly defined bounds!' if lmin > lmax or lmax > rmax or rmax > rmin

    @lmin = lmin
    @lmax = lmax
    @rmax = rmax
    @rmin = rmin
    @name = name
    @max_y = 1
  end

  def evaluate(x)
    f = case x
      when @lmin...@lmax
        (x-@lmin) / (@lmax-@lmin)
      when @lmax...@rmax
        1
      when @rmax..@rmin
        1 - (x-@rmax) / (@rmin-@rmax)
      else
        0
    end

    # clamp the output
    if f > @max_y then f = @max_y end
    f
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
      ds.title = @name
      ds.with = 'filledcurve'
      ds.linewidth = 1
    end
  end

end

class Triangle < MembershipFunction
  attr_accessor :max_y
  attr_reader :lmin, :max, :rmin, :max_y, :name

  def initialize(name, lmin, max, rmin)
    raise 'Wrongly defined bounds!' if lmin > max or max > rmin

    @lmin = lmin
    @max = max
    @rmin = rmin
    @name = name
    @max_y = 1
  end

  def evaluate(x)
    f = 0

    if @lmin == @max
      f = case x
        when @lmin
          1
        when @lmin..@rmin
          lerp(1, 0, normalise(@lmin, @rmin, x))
        else
          0
      end

    elsif @max == @rmin
      f = case x
        when @lmin..@rmin
          lerp(0, 1, normalise(@lmin, @rmin, x))
        else
          0
      end

    else
      f = case x
        when @lmin...@max
          lerp(0, 1, normalise(@lmin, @max, x))
        when @max..@rmin
          lerp(1, 0, normalise(@max, @rmin, x))
        else
          0
      end
    end

    # clamp the output
    if f > @max_y then f = @max_y end
    f
  end

  def get_dataset
    xs = Array.new
    ys = Array.new
    mf_range = @lmin..@rmin

    if @lmin == @max then xs << mf_range.first; ys << 0 end

    mf_range.step(PLOT_STEP) do |x|
      xs << x
      ys << evaluate(x)
    end

    if @max == @rmin then xs << mf_range.last; ys << 0 end

    Gnuplot::DataSet.new( [xs, ys] ) do |ds|
      ds.title = @name
      ds.with = 'filledcurve'
      ds.linewidth = 1
    end
  end

end

