#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
require './engine'
require './variable'
require './car'
require './road'
include Gosu
include Chingu

class Game < Chingu::Window
	
	def initialize
		super 640, 480, false
		self.input = { :esc => :exit }

		@road = Road.create( :x => $window.width/2.0,
												 :y => $window.height/2.0 )
		@road.input = { :holding_left => :move_left,
										:holding_right => :move_right }

		retrofy
		@car = Car.create( :x => $window.width/2.0,
											 :y => $window.height/2.0,
											 :image => Image['car.png'])
		@car.input = { :holding_up => :increase_speed,
									 :holding_down => :decrease_speed,
									 :released_space => :pause }
		@road.car = @car
	end

	def update
		super
		self.caption = "Fuzzy inference system racing car, FPS: #{$window.fps}"
	end

	def draw
		super
		draw_background
	end

	def draw_background
		grass_rect = Chingu::Rect.new(0, 0, width, height)
		fill_rect(grass_rect, Color::GREEN, -255)
	end
	
end

Game.new.show