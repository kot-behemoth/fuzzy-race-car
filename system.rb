#!/usr/bin/env ruby
require_relative 'variable'

tip = Variable.new('tip')

cheap_fset = TriangleMF.new(0, 1, 2)
average_fset = TriangleMF.new(2, 3, 4)
generous_fset = TriangleMF.new(4, 5, 6)

tip.fuzzy_sets[:cheap] = cheap_fset
tip.fuzzy_sets[:average] = average_fset
tip.fuzzy_sets[:generous] = generous_fset

tip.plot_sets
