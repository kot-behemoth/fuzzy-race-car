require 'rubygems'
require 'gnuplot'

def standard_continous_plot
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
end

def plot_sin
	offset = 0
	range = 0...5
	is_plotting = true

	continuos_plot(is_plotting) do |is_p, xs, ys|

		range.step(0.01) do |x|
			xs << offset + x
			ys << Math.sin(offset + x)
		end

		offset += 1
		if offset > 10
			is_p = false
		end
		puts "bump"
	end

end

def continuos_plot(is_plotting)
	Gnuplot.open do |gp|

		while is_plotting

			Gnuplot::Plot.new( gp ) do |plot|
				plot.mouse
				plot.view

				plot.yrange '[-1:1]'
				plot.xlabel 'x'
				plot.ylabel 'y'

				xs = Array.new
				ys = Array.new
				yield is_plotting, xs, ys

				plot.data = Array.new
				plot.data << Gnuplot::DataSet.new( [xs, ys] ) do |ds|
					ds.title = 'continuous data'
					ds.with = 'lines'
				end
			end
		end
	end
end

plot_sin