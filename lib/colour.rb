# Input rgb values 1...255
# based on http://forums.devshed.com/c-programming-42/rgb-to-hsv-conversion-rountine-162526.html
# returns h in the range of 0..360 deg
# s 0...100 
# v 0...100
def rgb_to_hsb(r,g,b)

  r = r.to_f / 255.0
  g = g.to_f / 255.0
  b = b.to_f / 255.0
  max = [r, g, b].max
  min = [r, g, b].min
  delta = max - min
  v = max * 100

  if (max != 0.0)
    s = delta / max *100
  else
    s = 0.0
  end

  if (s == 0.0) 
    h = 0.0
  else
    if (r == max)
      h = (g - b) / delta
    elsif (g == max)
      h = 2 + (b - r) / delta
    elsif (b == max)
      h = 4 + (r - g) / delta
    end

    h *= 60.0

    if (h < 0)
      h += 360.0
    end
  end

  [h, s, v]
end
