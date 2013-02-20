require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class Car < Chingu::GameObject
	trait :velocity
	trait :retrofy
	attr_accessor :speed, :screen_x, :screen_y, :text
	attr_writer :road

	def setup
		super
		@speed = 2
		self.scale = 5
		@engine = create_inference_engine
		@text = Chingu::Text.new("Angle: {@angle}", :x => 10, :y => 10, :zorder => 55)
	end

	def update
		super
		distance = @engine.variables[:distance]
		steering = @engine.variables[:steering]

		distance.crisp_input = @x - @road.x

		self.screen_x = @x
		self.screen_y = @y

		# debug
		# distance.plot_sets( { :plot_input => true } )
		@engine.infer
		# steering.plot_sets( { :plot_output => true } )
		# puts "Distance: #{distance.crisp_input} Steering: #{steering.crisp_output}"

		@angle = steering.crisp_output
		@velocity_x = Gosu.offset_x(@angle, @speed)

		@text.text = "Angle: #{@angle.round(2)}"
	end

	def draw
		super
		@text.draw
	end

	def increase_speed
		@speed += 0.5
	end

	def decrease_speed
		@speed -= 0.5
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

		d = $window.width/2.0

		distance = LinguisticVariable.create 'distance' do
			membership_function Triangle.new(:left, -d, -d, 0)
			membership_function Triangle.new(:centre, -d/2, 0, d/2)
			membership_function Triangle.new(:right, 0, d, d)
		end

		steering = LinguisticVariable.create 'steering (angle)' do
			membership_function Triangle.new(:left, -90, -90, 0)
			membership_function Triangle.new(:centre, -45, 0, 45)
			membership_function Triangle.new(:right, 0, 90, 90)
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
