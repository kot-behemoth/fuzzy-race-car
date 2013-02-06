class MembershipFunction
  PLOT_STEP = 0.1

  def evaluate(x)
  end
 
  def get_dataset
  end

end

def lerp(min, max, t)
  #raise 'Range error - min >= max' if min >= max
  raise 'Range error - t is not in [0, 1]' if t < 0 or t > 1

  min + t*(max - min).to_f
end

def normalise(min, max, x)
  raise 'Range error - min >= max' if min >= max

  (x-min) / (max-min).to_f
end

class Trapezoid < MembershipFunction
  attr_accessor :lmin, :lmax, :rmax, :rmin

  def initialize(lmin, lmax, rmax, rmin)
    @lmin = lmin
    @lmax = lmax
    @rmax = rmax
    @rmin = rmin
    raise 'Wrongly defined bounds!' if @lmin > @lmax or @lmax > @rmax or @rmax > @rmin
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
    raise 'Wrongly defined bounds!' if @lmin > @max or @max > @rmin
  end

  def evaluate(x)
    if @lmin == @max
      case x
        when @lmin
          1
        when @lmin..@rmin
          lerp(1, 0, normalise(@lmin, @rmin, x))
        else
          0
      end

    elsif @max == @rmin
      case x
        when @lmin..@rmin
          lerp(0, 1, normalise(@lmin, @rmin, x))
        else
          0
      end

    else
      case x
        when @lmin...@max
          lerp(0, 1, normalise(@lmin, @max, x))
        when @max..@rmin
          lerp(1, 0, normalise(@max, @rmin, x))
        else
          0
      end
    end
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
      ds.notitle
      ds.with = 'filledcurve'
      ds.linewidth = 1
    end
  end

end

