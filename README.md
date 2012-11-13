## Running the script

This was written and tested on Mac OS X Lion, so I can't guarantee this running
on any other systems.

To install all the gems, simply run `bundle install`.

## Catmull-Rom Spline Plotter

A simple GNUplot-based CR splines plotter. Comes with a few samples packaged —
just uncomment various plots. To run, execute `ruby cr.rb`.

__Note:__ I'm using my own fork of the [ruby_gnuplot][ruby_gnuplot] gem that
allows the `linecolor` to be specified, so use that for now. I'll make a pull
request to master quite soon.

For more info, read my [post about it][post].

[post]: http://gregory.goltsov.info/blog/fun-with-catmull-rom-splines-using-gnuplot-and-ruby

