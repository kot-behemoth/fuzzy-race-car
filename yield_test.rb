require 'rubygems'
require 'gnuplot'

def Gnuplot.start( persist=true )
	cmd = Gnuplot.gnuplot( persist )
	return IO::popen( cmd, "w+")
end

def plot_sin(gp, offset, range)
	Gnuplot::Plot.new( gp ) do |plot|
		plot.mouse
		plot.view

		plot.yrange '[-1:1]'
		plot.xlabel 'x'
		plot.ylabel 'y'

		xs = Array.new
		ys = Array.new
		range.step(0.01) do |x|
			ys << Math.sin(offset + x)
			xs << offset + x
		end

		plot.data = Array.new
		plot.data << Gnuplot::DataSet.new( [xs, ys] ) do |ds|
			ds.title = 'continuous data'
			ds.with = 'lines'
		end
	end
end

offset = 0
range = 0...5

gp = Gnuplot.start

while( offset < 100 )

	plot_sin(gp, offset, range)

	offset += 1
end

gp.close
