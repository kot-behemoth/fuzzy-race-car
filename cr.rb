# encoding: utf-8
require 'gnuplot'
require 'matrix'

points = [ [-1, -1],
           [ 0,  0],
           [ 3,  4],
           [-1,  2],
           [ 0,  0],
           [ 2, -1] ]

def S( t, τ, control_points, start_point )
  τ = τ.to_f
  cr_matrix = Matrix[ [  0,   1,     0,  0],
                      [ -τ,   0,     τ,  0],
                      [2*τ, τ-3, 3-2*τ, -τ],
                      [ -τ, 2-τ,   τ-2,  τ] ]

  p = Matrix[ control_points[start_point - 2],
              control_points[start_point - 1],
              control_points[start_point],
              control_points[start_point + 1] ]

  c = ( cr_matrix*p ).row_vectors

  # Compute the actual S(t) vector equation
  c[0] + c[1]*t + c[2]*(t**2) + c[3]*(t**3)
end

def generate_full_CR( step, points, τ )
  segments = Array.new

  # -3 is because we're starting from p_i-2 to p_i+1
  # so we are also starting from the point p_i+2
  (points.length-3).times do |i|
    (0..1).step( step ) { |t| segments << S( t, τ, points, 2+i ) }
  end

  segments
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |p|

    p.mouse
    p.view

    #p.terminal "wxt size 350,262 enhanced font 'Verdana,10' persist"

    #p.terminal "svg fname 'Helvetica Neue' fsize 10"
    #p.output 'introduction.svg'

    #p.terminal "epslatex size 3.5,2.62 standalone color colortext 10"
    #p.output 'introduction.tex'

    #p.terminal "pngcairo size 350,262 enhanced font 'Helvetica,10'"
    #p.output 'introduction.png'
  
    #p.xrange "[-10:10]"
    p.title  'Catmull-Rom Spline'
    p.ylabel 'y'
    p.xlabel 'x'

    # Multiple curves
    (0..2).step(0.1) do |τ|
      cr_curve = generate_full_CR( 0.01, points, τ )
      x_cr = cr_curve.map { |p| p[0] }
      y_cr = cr_curve.map { |p| p[1] }
      p.data <<
        Gnuplot::DataSet.new( [x_cr, y_cr] ) { |ds|
          ds.with = 'lines'
          ds.linewidth = 2
        }
    end

    # Single curve
    #cr_curve = generate_full_CR( 0.01, points, 1 )
    #x_cr = cr_curve.map { |p| p[0] }
    #y_cr = cr_curve.map { |p| p[1] }
    #p.data <<
    #  Gnuplot::DataSet.new( [x_cr, y_cr] ) { |ds|
    #    ds.with = 'lines'
    #	  ds.linewidth = 2
    #  }
    
    # Add control points
    x = points.map { |p| p[0] }
    y = points.map { |p| p[1] }
    p.data <<
      Gnuplot::DataSet.new( [x, y] ) { |ds|
        ds.with = 'points'
      }

  end

end

