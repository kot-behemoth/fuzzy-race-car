#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
require './engine'
require './variable'
include Gosu
include Chingu

class Game < Chingu::Window
	def initialize
		super 640, 480, false
		self.input = { :esc => :exit }

		@player = Player.create( :x => $window.width/2.0,
														 :y => $window.height/2.0,
														 :image => Image["spaceship.png"])
		# @player.input = { :holding_left => :rotate_left,
		# 									:holding_right => :rotate_right,
		# 									:holding_up => :move_forward,
		# 									:holding_down => :move_backward }
		@road = Road.create( :x => $window.width/2.0,
												 :y => $window.height/2.0 )
		@road.input = { :holding_left => :move_left,
										:holding_right => :move_right }
		@player.road = @road
	end

	def update
		super
		self.caption = "Fuzzy inference system racing car, FPS: #{$window.fps}"
	end
end

class Road < Chingu::GameObject
	attr_accessor :rect

	def setup
		super
		@rect = Chingu::Rect.new(0, 0, 10, $window.height * 0.75)
	end

	def update
		super
		@rect.center = [@x, @y]
	end

	def draw
		super
		# Chingu::Helpers::GFX.fill_rect(@rect, Color::WHITE)

		color = Color::WHITE
		rect = @rect

		$window.draw_quad(rect.x, rect.y, color,
                      rect.right, rect.y, color,
                      rect.right, rect.bottom, color,
                      rect.x, rect.bottom, color,
                      zorder, :default)
	end

	def move_left;  @x -= 3; end
	def move_right; @x += 3; end

end

class Player < Chingu::GameObject
	trait :velocity
	attr_accessor :speed
	attr_writer :road

	def setup
		super
		@speed = 10
		@engine = create_inference_engine
	end

	def update
		distance = @engine.variables[:distance]
		steering = @engine.variables[:steering]

		distance.crisp_input = @x - @road.x

		# debug
		# distance.plot_sets( { :plot_input => true } )
		@engine.infer
		# steering.plot_sets( { :plot_output => true } )
		# puts "Distance: #{distance.crisp_input} Steering: #{steering.crisp_output}"

		@angle = steering.crisp_output*10.0
		@velocity_x = Gosu.offset_x(@angle, @speed)
		super
	end

	def move_forward
		@velocity_x += Gosu.offset_x(@angle, @speed)
		@velocity_y += Gosu.offset_y(@angle, @speed)
	end

	def move_backward
		@velocity_x -= Gosu.offset_x(@angle, @speed)
		@velocity_y -= Gosu.offset_y(@angle, @speed)
	end

	def rotate_right;  @angle += 3 unless @angle >= 180; end
	def rotate_left;   @angle -= 3 unless @angle <= -180; end

	private
	def create_inference_engine
		engine = InferenceEngine.new

		# Fuzzification

		d = $window.height/2.0

		distance = LinguisticVariable.create 'distance' do
			membership_function Triangle.new(:left, -d, -d, 0)
			membership_function Triangle.new(:centre, -d/2, 0, d/2)
			membership_function Triangle.new(:right, 0, d, d)
		end

		steering = LinguisticVariable.create 'steering (angle)' do
			membership_function Triangle.new(:left, -20, -20, 0)
			membership_function Triangle.new(:centre, -10, 0, 10)
			membership_function Triangle.new(:right, 0, 20, 20)
		end

		engine.variables[:distance] = distance
		engine.variables[:steering] = steering

		distance.crisp_input = 0
		distance.plot_sets( { :plot_input => true } )
		steering.plot_sets

		# Rules

		engine.rules << Rule.new.IF(:left, distance).THEN(:right, steering)
		engine.rules << Rule.new.IF(:centre, distance).THEN(:centre, steering)
		engine.rules << Rule.new.IF(:right, distance).THEN(:left, steering)

		engine
	end
end

Game.new.show