#!/usr/bin/env ruby
require_relative 'variable'

tip = Variable.new('tip')

cheap_fset = Triangle.new(0, 1, 2)
average_fset = Trapezoid.new(2, 2.5, 3.5, 4)
generous_fset = Triangle.new(4, 5, 6)

tip.fuzzy_sets[:cheap] = cheap_fset
tip.fuzzy_sets[:average] = average_fset
tip.fuzzy_sets[:generous] = generous_fset

tip.plot_sets
