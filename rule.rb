class Rule
  attr_reader :if_var, :if_mf, :then_var, :then_mf

  def initialize(if_mf, if_var, then_mf, then_var)
    raise "Variable #{if_var.name} does not have the #{if_mf.to_s} membership function!" if if_var.fuzzy_sets[if_mf].nil?
    raise "Variable #{then_var.name} does not have the #{then_mf.to_s} membership function!" if then_var.fuzzy_sets[then_mf].nil?

    @if_var = if_var
    @if_mf = if_mf
    @then_var = then_var
    @then_mf = then_mf
  end

  def evaluate
    @then_var.fuzzy_sets[@then_mf].max_y = \
      @if_var.fuzzy_sets[@if_mf].evaluate( @if_var.crisp_value )
  end

end
