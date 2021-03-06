require 'rubygems'
require 'gnuplot'

def Gnuplot.start( persist=true )
  cmd = Gnuplot.gnuplot( persist )
  return IO::popen( cmd, "w+")
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

def clamp(val, min, max)
  case
    when val <= min
      min
    when val >= max
      max
    else
      val
  end
end

def max(a, b)
  if a > b
    a
  else
    b
  end
end

def min(a, b)
  if a < b
    a
  else
    b
  end
end

module Fuzzy

  def Fuzzy.OR(a, b)
    min a, b
  end

  def Fuzzy.AND(a, b)
    max a, b
  end

end