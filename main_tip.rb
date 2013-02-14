#!/usr/bin/env ruby
require './engine'
require './variable'

engine = InferenceEngine.new

# Fuzzification

service = Variable.create 'service' do
	add_mf Triangle.new(:poor, 0, 0, 4)
	add_mf Trapezoid.new(:good, 1, 4, 6, 9)
	add_mf Triangle.new(:excellent, 6, 9, 9)
end

tip = Variable.create 'tip' do
	add_mf Triangle.new(:cheap, 0, 1, 2)
	add_mf Trapezoid.new(:average, 1, 2.5, 3.5, 5)
	add_mf Triangle.new(:generous, 4, 5, 6)
end

engine.variables[:service] = service
engine.variables[:tip] = tip

service.crisp_input = 1.5
service.plot_sets( { :plot_input => true } )
tip.plot_sets

# Rules

engine.rules << Rule.new.IF(:poor, service).THEN(:cheap, tip)
engine.rules << Rule.new.IF(:good, service).THEN(:average, tip)
engine.rules << Rule.new.IF(:excellent, service).THEN(:generous, tip)


engine.infer
tip.plot_sets( { :plot_output => true } )
