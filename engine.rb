require_relative 'rule'
require_relative 'variable'

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

    @variables.values.each do |var|
      var.compute_crisp_output if var.is_output
    end

  end

end
