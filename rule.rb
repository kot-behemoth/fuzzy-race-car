class Rule
	# pairs are [ var, mf ]
	attr_reader :if_pairs, :then_var, :then_mf

	def self.create(&block)
		variable = Rule.new
		variable.instance_eval(&block) if block_given?
		variable
	end

	def initialize
		@if_pairs = Array.new
		@then_var = nil
		@then_mf = nil
	end

	def IF(if_var, if_mf)
		raise "Variable #{if_var.name} does not have the #{if_mf.to_s} membership function!" if if_var.membership_functions[if_mf].nil?
		@if_pairs << [if_var, if_mf]
		self
	end

	def THEN(then_var, then_mf)
		raise "Variable #{then_var.name} does not have the #{then_mf.to_s} membership function!" if then_var.membership_functions[then_mf].nil?
		@then_var = then_var
		@then_mf = then_mf
		self
	end

	def AND
		self
	end

	def evaluate!
		# raise "Not a composite rule!" if @if_pairs.size != 2
		aggregate = 1.0

		@if_pairs.each do |if_var, if_mf|
			if_mf_weight = if_var.membership_functions[if_mf].evaluate( if_var.crisp_input )
			aggregate = Fuzzy.OR(aggregate, if_mf_weight)
		end

		then_mf_weight = @then_var.membership_functions[@then_mf].weight
		@then_var.membership_functions[@then_mf].weight = Fuzzy.AND(then_mf_weight, aggregate)

		# Sanity check
		raise "Wrongly adjusted weight!" unless then_mf_weight >= 0 and then_mf_weight <= 1
	end

	def reset_state
		@then_var.membership_functions[@then_mf].weight = 0.0
	end

end
