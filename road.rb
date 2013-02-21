require 'rubygems'
require 'chingu'
include Gosu

class Road < Chingu::GameObject
	attr_accessor :middle_line_rect, :tarmac_rect
	attr_accessor :car
	attr_reader :oscillating

	def setup
		super
		oscillating = false
		@middle_line_rect = Chingu::Rect.new(0, 0, 8, $window.height)
		@tarmac_rect = Chingu::Rect.new(0, 0, 300, $window.height)
	end

	def update
		super
		oscillate

		car.road_x = @x

		@middle_line_rect.center = [@x, @y]
		@tarmac_rect.center = [@x, @y]
	end

	def draw
		super
		$window.fill_rect(@middle_line_rect, Color::WHITE, 1)
		$window.fill_rect(@tarmac_rect, Color::BLACK, 0)
	end

	def move_left
		@x -= 3 unless @x <= 0
	end

	def move_right
		@x += 3 unless @x >= $window.width
	end

	def toggle_oscillation; @oscillating = !@oscillating; end

	def oscillate
		if oscillating
			@x = $window.width/2.0 * (1 + Math.sin(Gosu::milliseconds/4000.0))#/@car.speed))
		end
	end

end
