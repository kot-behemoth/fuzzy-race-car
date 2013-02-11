#!/usr/bin/env ruby
require_relative 'engine'
require_relative 'variable'

engine = InferenceEngine.new

# Fuzzification

service = Variable.new('service')

service.add_mf Triangle.new(:poor, 0, 0, 4)
service.add_mf Trapezoid.new(:good, 1, 4, 6, 9)
service.add_mf Triangle.new(:excellent, 6, 9, 9)

tip = Variable.new('tip')

tip.add_mf Triangle.new(:cheap, 0, 1, 2)
tip.add_mf Trapezoid.new(:average, 1, 2.5, 3.5, 5)
tip.add_mf Triangle.new(:generous, 4, 5, 6)

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

service.crisp_input = 1.5
engine.infer
tip.plot_sets false, true
