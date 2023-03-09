class Verify

  def call(attribute, interface, value, options = {})
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