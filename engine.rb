require_relative 'rule'
require_relative 'variable'

class InferenceEngine
  attr_accessor :rules, :variables
  
  def initialize
    @rules = Array.new
    @variables = Hash.new
  end

  def infer
    rules.each do |rule|
      rule.evaluate!
    end
  end

end
