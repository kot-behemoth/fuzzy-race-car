require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class Road < Chingu::GameObject
	attr_accessor :rect

	def setup
		super
		@rect = Chingu::Rect.new(0, 0, 10, $window.height)
	end

	def update
		super
		@rect.center = [@x, @y]
	end

	def draw
		super
		$window.fill_rect @rect, Color::WHITE, 1
	end

	def move_left;  @x -= 3; end
	def move_right; @x += 3; end

end
