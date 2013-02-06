#!/usr/bin/env ruby
require_relative 'variable'

# Fuzzification

service = Variable.new('service')

service.fuzzy_sets[:poor] = Triangle.new(0, 0, 4)
service.fuzzy_sets[:good] = Trapezoid.new(1, 4, 6, 9)
service.fuzzy_sets[:excellent] = Triangle.new(6, 9, 9)

tip = Variable.new('tip')

tip.fuzzy_sets[:cheap] = Triangle.new(0, 1, 2)
tip.fuzzy_sets[:average] = Trapezoid.new(2, 2.5, 3.5, 4)
tip.fuzzy_sets[:generous] = Triangle.new(4, 5, 6)

#tip.plot_sets
service.plot_sets
