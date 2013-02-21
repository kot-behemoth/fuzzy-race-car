require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class Car < Chingu::GameObject
	trait :velocity
	trait :retrofy
	attr_accessor :speed, :screen_x, :screen_y, :text
	attr_writer :road_x
	attr_reader :previous_distance

	def setup
		super
		@speed = 2
		@previous_distance = 0
		self.scale = 5
		@engine = create_inference_engine
		@text = Chingu::Text.new("Angle: {@angle}", :x => 10, :y => 10, :zorder => 55, :color => Color::RED, :factor_x => 2.0, :factor_y => 2.0)
	end

	def update
		super
		# retrofy setup
		self.screen_x = @x
		self.screen_y = @y

		@velocity_x = Gosu.offset_x(@angle, @speed)

		update_fuzzy

		@text.text = "Angle: #{@angle.round(2)}"
	end

	def update_fuzzy()
		distance_var = @engine.variables[:distance]
		steering_var = @engine.variables[:steering]
		# delta_var = @engine.variables[:delta]

		# Update inputs
		distance = @x - @road_x
		distance_var.crisp_input = distance
		# delta_var.crisp_input = (@previous_distance - distance).abs

		@previous_distance = distance

		# Infer
		@engine.infer

		# Update outputs
		@angle = steering_var.crisp_output
		# @speed = speed.crisp_output

		# Plots etc
		distance_var.plot_sets( { :plot_input => true } )
		# delta.plot_sets( { :plot_input => true } )
		steering_var.plot_sets( { :plot_output => true } )
		# speed.plot_sets( { :plot_output => true } )
		@engine.reset_state
	end

	def draw
		super
		@text.draw
	end

	def increase_speed
		@speed += 0.5 unless @speed >= 15
	end

	def decrease_speed
		@speed -= 0.5 unless @speed <= 0.5
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

		d = $window.width / 2.0

		distance = LinguisticVariable.create 'distance' do
			membership_function Triangle.new(:left, -d, -d, 0)
			membership_function Triangle.new(:centre, -d/2, 0, d/2)
			membership_function Triangle.new(:right, 0, d, d)
		end

		delta = LinguisticVariable.create 'delta' do
			membership_function Triangle.new(:small, 0, 25, 50)
			membership_function Triangle.new(:medium, 25, 50, 75)
			membership_function Triangle.new(:big, 50, 75, 100)
		end

		steering = LinguisticVariable.create 'steering' do
			membership_function Triangle.new(:left, -90, -90, 0)
			membership_function Triangle.new(:centre, -45, 0, 45)
			membership_function Triangle.new(:right, 0, 90, 90)
		end
		steering.is_output = true

		engine.variables[:distance] = distance
		# engine.variables[:delta] = delta
		engine.variables[:steering] = steering

		# distance.crisp_input = 0
		# distance.plot_sets( { :plot_input => true } )
		# steering.plot_sets

		# Rules

		engine.rules << Rule.create do
			IF( :left, distance ).THEN( :right, steering )
		end

		engine.rules << Rule.create do
			IF( :centre, distance ).THEN( :centre, steering )
		end

		engine.rules << Rule.create do
			IF( :right, distance ).THEN( :left, steering )
		end


		# engine.rules << Rule.new.IF(:left, distance).THEN(:right, steering)
		# engine.rules << Rule.new.IF(:centre, distance).THEN(:centre, steering)
		# engine.rules << Rule.new.IF(:right, distance).THEN(:left, steering)

		# engine.rules << Rule.new.IF(:small, delta).THEN(:medium, speed)
		# engine.rules << Rule.new.IF(:big, delta).THEN(:fast, speed)

		engine
	end
end
