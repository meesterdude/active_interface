class ActiveInterface::InterfaceError < StandardError

  def initialize(errors, interface, klass, method_name: )
    @interface = interface
    @errors = errors
    @klass = klass
    @method_name = method_name
  end

  def message
    "Violation of #{@interface} in #{@klass}##{@method_name}: #{@errors}"
  end

end