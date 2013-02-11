# encoding: utf-8
require 'gnuplot'
require 'matrix'
require 'colormath'

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

def CR_curve( t_step, points, τ )
  segments = Array.new

  # -3 is because we're starting from p_i-2 to p_i+1
  # so we are also starting from the point p_i+2
  (points.length-3).times do |i|
    (0..1).step( t_step ) { |t| segments << S( t, τ, points, 2+i ) }
  end

  # Return the points as [xs, ys] - easy consumption for DataSet
  [segments.map{|p| p[0]}, segments.map{|p| p[1]}] 
end


Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |p|
    p.mouse
    p.view

    #p.terminal "svg size 800,600 fname 'Helvetica Neue' fsize 10"
    #p.output 'cr_plot.svg'

    #p.terminal "epslatex size 3.5,2.62 standalone color colortext 10"
    #p.output 'cr_plot.tex'

    #p.terminal "png size 800,600 font 'Helvetica Neue, 11'"
    #p.output 'cr_plot.png'
    
    p.terminal "pngcairo size 350,262 enhanced font 'Helvetica Neue,10'"
    p.output 'cr_plot.png'
  
    #p.xrange "[-10:10]"
    p.title  'Catmull-Rom Spline'
    p.xlabel 'x'
    p.ylabel 'y'
    #p.border 'linewidth 1.5'
    

    ##############
    # Single curve
    ##############
    p.data <<
      Gnuplot::DataSet.new( CR_curve( 0.01, points, 1 ) ) do |ds|
        ds.notitle
        ds.with = 'lines'
        ds.linewidth = 1
        colour = ColorMath::HSL.new(337, 64, 0.56).hex
        ds.linecolor = "rgb '#{colour}'"
      end

    #################
    # Multiple curves
    #################
   
    # This is a double plot, gives a black and white gradient plot
    # with each curve's blackness depending on how close to 1 τ is.
    #(0..1).step(0.01) do |τ|
    #  p.data <<
    #    Gnuplot::DataSet.new( CR_curve(0.01, points, τ) ) do |ds|
    #      ds.notitle
    #      ds.with = 'lines'
    #      ds.linewidth = 2
    #      colour = ColorMath::HSL.new(0, 0, (1-τ+0.2)/1.0).hex
    #      ds.linecolor = "rgb '#{colour}'"
    #    end
    #end
    #(1..5).step(0.01) do |τ|
    #  p.data <<
    #    Gnuplot::DataSet.new( CR_curve(0.01, points, τ) ) do |ds|
    #      ds.notitle
    #      ds.with = 'lines'
    #      ds.linewidth = 2
    #      colour = ColorMath::HSL.new(0, 0, (τ-1)/(5-1)).hex
    #      ds.linecolor = "rgb '#{colour}'"
    #    end
    #end

    # Just a crazy plot with normal GNUplot-provided colours
    #(0..50).step(1) do |τ|
    #  p.data <<
    #    Gnuplot::DataSet.new( CR_curve(0.01, points, τ) ) do |ds|
    #      ds.notitle
    #      ds.with = 'lines'
    #      ds.linewidth = 2
    #    end
    #end

    # Another funky plot, similar to the previous one, but τ only goes up to 5
    #(0..5).step(0.1) do |τ|
    #  p.data <<
    #    Gnuplot::DataSet.new( CR_curve(0.01, points, τ) ) do |ds|
    #      ds.notitle
    #      ds.with = 'lines'
    #      ds.linewidth = 2
    #    end
    #end


    ################
    # Control points
    ################
    x = points.map { |p| p[0] }
    y = points.map { |p| p[1] }
    p.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
        ds.notitle
        ds.with = 'points'
        ds.linecolor = "rgb '#000'"
      end

  end
end

