class ActiveInterface::Contract

  def initialize(_binding, _output = nil)
   @_binding = _binding
   @output = _output
  end

  def call(&block)
   result = block.call self
   output
  end

  def enforce_input(value_name, options)
    callee = @_binding.eval("__method__")
    interface = @_binding.eval("self").method(callee).owner
    value = @_binding.eval(value_name.to_s)
    verify(value_name, interface, value, options)
  end


  def enforce_output(options)
    callee = @_binding.eval("__method__")
    interface = @_binding.eval("self").method(callee).owner
    verify(:output, interface, output, options)
  end

  def output
    @output ||= @_binding.eval("super")
  end

  def verify(attribute, interface, value, options = {})
    Verify.call(attribute, interface, value, options)
  end

end

