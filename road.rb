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
