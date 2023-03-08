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

  private

  def output
    @output ||= @_binding.eval("super")
  end

  def verify(attribute, interface, value, options = {})
    errors = []
    
    if options[:presence] && value.nil?
      errors << "#{attribute} can't be blank"
    end

    if options[:range] && !options[:range].include?(value)
      errors << "#{attribute} is not within the range #{options[:in]}"
    end

    if options[:length] && !options[:length].include?(value.length)
      errors << "#{attribute} must be between #{options[:length]} characters long"
    end

    if options[:regex] && !(options[:regex] =~ value)
      errors << "#{attribute} is invalid"
    end

    if options[:kind_of] && !Array(options[:kind_of]).include?(value.class)
      errors << "#{attribute} must be a kind of #{options[:kind_of]}"
    end
    if errors.empty?
      nil
    else
      klass = @_binding.eval("self").class
      meth = @_binding.eval("__method__")
      raise(InterfaceError.new(errors, interface, klass, method_name: meth))
    end
  end

end

