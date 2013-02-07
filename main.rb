#!/usr/bin/env ruby
require_relative 'engine'
require_relative 'variable'

engine = InferenceEngine.new

# Fuzzification

service = Variable.new('service')

service.fuzzy_sets[:poor] = Triangle.new('poor', 0, 0, 4)
service.fuzzy_sets[:good] = Trapezoid.new('good', 1, 4, 6, 9)
service.fuzzy_sets[:excellent] = Triangle.new('excellent', 6, 9, 9)

tip = Variable.new('tip')

tip.fuzzy_sets[:cheap] = Triangle.new('cheap', 0, 1, 2)
tip.fuzzy_sets[:average] = Trapezoid.new('average', 2, 2.5, 3.5, 4)
tip.fuzzy_sets[:generous] = Triangle.new('generous', 4, 5, 6)

engine.variables[:service] = service
engine.variables[:tip] = tip

service.plot_sets
tip.plot_sets

# Rules

rule_poor_service_cheap_tip = Rule.new(:poor, service, :cheap, tip)
rule_good_service_average_tip = Rule.new(:good, service, :average, tip)
rule_excellent_service_generous_tip = Rule.new(:excellent, service, :generous, tip)

engine.rules << rule_poor_service_cheap_tip
engine.rules << rule_good_service_average_tip
engine.rules << rule_excellent_service_generous_tip

service.crisp_input = 0.3
#engine.infer
#tip.plot_sets
