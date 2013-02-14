require 'rubygems'
require 'gnuplot'

Gnuplot.open do |gp|

	offset = 0
	range = 0...5

	while true

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
			offset += 1
		end

		sleep 0.1

	end
end
