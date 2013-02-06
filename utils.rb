def lerp(min, max, t)
  #raise 'Range error - min >= max' if min >= max
  raise 'Range error - t is not in [0, 1]' if t < 0 or t > 1

  min + t*(max - min).to_f
end

def normalise(min, max, x)
  raise 'Range error - min >= max' if min >= max

  (x-min) / (max-min).to_f
end

