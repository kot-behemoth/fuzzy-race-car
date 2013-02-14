#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
require './engine'
require './variable'
include Gosu
include Chingu

engine = InferenceEngine.new

# Fuzzification

distance = Variable.create 'distance' do
	membership_function Triangle.new(:left, -10, -10, -2.5)
	membership_function Triangle.new(:centre, -5, 0, 5)
	membership_function Triangle.new(:right, 2.5, 10, 10)
end

steering = Variable.create 'steering (angle)' do
	membership_function Triangle.new(:left, -20, -20, -5)
	membership_function Triangle.new(:centre, -10, 0, 10)
	membership_function Triangle.new(:right, 5, 20, 20)
end

engine.variables[:distance] = distance
engine.variables[:steering] = steering

# service.crisp_input = 1.5
# service.plot_sets( { :plot_input => true } )
# tip.plot_sets

# Rules

engine.rules << Rule.new.IF(:left, distance).THEN(:right, steering)
engine.rules << Rule.new.IF(:centre, distance).THEN(:centre, steering)
engine.rules << Rule.new.IF(:right, distance).THEN(:left, steering)

# engine.infer

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
		self.caption = 'Fuzzy inference system racing car'
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
		@speed = 0.1
	end

	def update
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
end

Game.new.show