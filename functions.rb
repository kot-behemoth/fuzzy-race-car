# f(lmin) = f(rmin) = 0
# f(max) = 1
def triangle_mf(x, lmin, max, rmin)
	case x
		when x < lmin
			return 0
		when lmin...max
			(x-lmin) / (max-lmin)
		when max...rmin
			1 - (x-max)/(rmin-max)
		when x >= rmin
			0
		else
			error "Wrong range!"
	end
end

class TriangleMF
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
        1 - (x-@max)/(@rmin-@max)
      when x >= @rmin
        0
      else
        error "Wrong range!"
    end
  end

  def get_dataset
    xs, ys = Array.new
    mf_range = @lmin...@rmin
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
