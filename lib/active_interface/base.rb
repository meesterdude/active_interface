require 'pry'
require_relative "interface_contract"
class Module
  alias_method :interface?, :<
end


module ActiveInterface::Base


    def prepended(klass)
      klass_methods = klass.public_instance_methods(false)
      messages = []
      missing_methods = public_instance_methods(false) - klass_methods
      if (missing_methods.size > 0)
        messages << "#{klass} is missing implementation(s) for ##{missing_methods.join(', #')}"
      end
      public_instance_methods(false).each do |method_name|
        interface_method = instance_method(method_name)
        class_method = klass.instance_method(method_name)
      
        interface_params = interface_method.parameters.map(&:last)
        class_params = class_method.parameters.map(&:last)
        
        unless interface_params == class_params
          messages << "method signature for #{method_name} should be #{interface_params} but was #{class_params}"
        end
      end

      missing_attributes = klass::REQUIRED_ATTRIBUTES - klass_methods
      if (missing_attributes.size > 0)
        messages << "#{klass} is missing attributes #{missing_attributes.join(', ')}"
      end

      if messages.size > 0
        raise "#{messages.size} errors verifying #{klass} conforms to #{self} \n" + messages.join("\n")
      end

  end

end
