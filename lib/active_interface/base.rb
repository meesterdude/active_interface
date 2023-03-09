
class Module
  alias_method :has_interface?, :<
end


module ActiveInterface
  module Base

    module ClassMethods
      def prepended(klass)
        messages = []
        ensure_methods_implemented(klass, messages)
        ensure_method_signatures(klass, messages)
        ensure_attributes_defined(klass, messages)

        if messages.size > 0
          raise "#{messages.size} errors verifying #{klass} conforms to #{self} \n" + messages.join("\n")
        end
      end

      private

      def ensure_attributes_defined(klass, messages)
        missing_attributes = klass::REQUIRED_ATTRIBUTES - klass.public_instance_methods(false)
        if (missing_attributes.size > 0)
          messages << "#{klass} is missing attributes #{missing_attributes.join(', ')}"
        end
      end

      def ensure_methods_implemented(klass, messages)
        missing_methods = public_instance_methods(false) - klass.public_instance_methods(false)
        if (missing_methods.size > 0)
          messages << "#{klass} is missing implementation(s) for ##{missing_methods.join(', #')}"
        end
      end

      def ensure_method_signatures(klass, messages)
        public_instance_methods(false).each do |method_name|
          interface_method = instance_method(method_name)
          class_method = klass.instance_method(method_name).super_method
          next if class_method.nil?
          interface_params = interface_method.parameters.map(&:last)
          class_params = class_method.parameters.map(&:last)
          
          unless interface_params == class_params
            messages << "method signature for #{method_name} should be #{interface_params} but was #{class_params}"
          end
        end
      end
    end

    def interface_contract(_binding)
      ActiveInterface::Contract.new(_binding).call
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end
  end
end