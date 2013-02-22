require './rule'
require './variable'

class InferenceEngine
  attr_accessor :rules, :variables
  
  def initialize
    @rules = Array.new
    @variables = Hash.new
  end

  def infer
    # Apply rules
    rules.each do |rule|
      rule.evaluate!
    end

    # Compute the output
    @variables.values.each do |var|
      var.compute_crisp_output if var.is_output
    end

  end

  def reset_state
    rules.each do |rule|
      rule.reset_state
    end
  end

end
  