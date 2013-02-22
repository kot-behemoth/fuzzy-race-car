require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class Car < Chingu::GameObject

	MAX_ANGLE = 90
	MAX_DELTA = 30.0

	trait :velocity
	trait :retrofy
	attr_accessor :speed, :screen_x, :screen_y, :text
	attr_writer :road_x
	attr_reader :previous_distance, :d

	def setup
		super
		@speed = 2
		@d = 0
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

		@text.text = "Distance: #{d.round(2)}\nAngle: #{@angle.round(2)}"
	end

	def update_fuzzy()
		distance_var = @engine.variables[:distance]
		steering_var = @engine.variables[:steering]
		delta_var = @engine.variables[:delta]

		# Update inputs
		distance = @x - @road_x
		distance_n = distance / $window.width
		distance_var.crisp_input = distance_n
		@d = distance_n
		delta_var.crisp_input = (distance - @previous_distance)/MAX_DELTA

		@previous_distance = distance

		# Infer
		@engine.infer

		# Update outputs
		new_angle = steering_var.crisp_output * MAX_ANGLE
		raise "New angle is crazy: #{new_angle}!" if new_angle.nan? or new_angle < -65 or new_angle > 65
		@angle = new_angle

		# Plots etc
		distance_var.plot_sets( { :plot_input => true } )
		delta_var.plot_sets( { :plot_input => true } )
		steering_var.plot_sets( { :plot_output => true } )

		# Reset the inference engine state
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

		distance = LinguisticVariable.create 'distance' do
			add_mf Triangle.new(:left, 		-1, -1, 0)
			add_mf Triangle.new(:centre, 	-0.1, 0, 0.1)
			add_mf Triangle.new(:right, 	 0, 1, 1)
		end

		delta = LinguisticVariable.create 'delta' do
			add_mf Triangle.new(:left, 			-1, -1, 0)
			add_mf Triangle.new(:centre,		-0.5, 0, 0.5)
			add_mf Triangle.new(:right,  		 0, 1, 1)
		end

		steering = LinguisticVariable.create 'steering' do
			set_as_output

			add_mf Triangle.new(:big_left, 		-1, -1, -0.75)
			add_mf Triangle.new(:left, 				-1, -1, 0)
			add_mf Triangle.new(:centre, 			-0.5, 0, 0.5)
			add_mf Triangle.new(:right, 			 0, 1, 1)
			add_mf Triangle.new(:big_right, 	 0.75, 1, 1)
		end

		engine.variables[:distance] = distance
		engine.variables[:delta] 		= delta
		engine.variables[:steering] = steering

		# Rules

		# 							delta
		# 
		#						 | R | C | L
		#						-+---+---+---
		#						R| L | L | C 
		#	distance	-+---+---+---
		#						C| L | C | R 
		#						-+---+---+---
		#						L| C | R | R 

		engine.rules << Rule.new.IF( distance, :right ).AND.IF( delta, :right  ).THEN( steering, :big_left )
		engine.rules << Rule.new.IF( distance, :right ).AND.IF( delta, :centre ).THEN( steering, :left )
		engine.rules << Rule.new.IF( distance, :right ).AND.IF( delta, :left   ).THEN( steering, :centre )

		engine.rules << Rule.new.IF( distance, :centre ).AND.IF( delta, :right  ).THEN( steering, :left )
		engine.rules << Rule.new.IF( distance, :centre ).AND.IF( delta, :centre ).THEN( steering, :centre )
		engine.rules << Rule.new.IF( distance, :centre ).AND.IF( delta, :left   ).THEN( steering, :right )

		engine.rules << Rule.new.IF( distance, :left ).AND.IF( delta, :right  ).THEN( steering, :centre )
		engine.rules << Rule.new.IF( distance, :left ).AND.IF( delta, :centre ).THEN( steering, :right )
		engine.rules << Rule.new.IF( distance, :left ).AND.IF( delta, :left   ).THEN( steering, :big_right )

		engine
	end
end
