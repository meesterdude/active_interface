require "spec_helper"
require 'pry'

RSpec.describe ActiveInterface::Base do
  let(:interface_module) { Module.new { |mod| mod::REQUIRED_ATTRIBUTES = [:bar]; def foo(a, b); end }.include described_class }
  let(:klass) { Class.new() {attr_accessor :bar; def foo(a, b); binding.pry; end } }

  describe '#prepended' do
    context 'when interface methods are implemented' do
      it 'does not raise an error' do
        expect { klass.prepend(interface_module) }.not_to raise_error
      end
    end

    context 'when interface methods are not implemented' do
      let(:interface_module) { Module.new { |mod| mod::REQUIRED_ATTRIBUTES = [:bar]; def baz(a, b);end}.include described_class }

      it 'raises an error' do
        expect { klass.prepend(interface_module) }.to raise_error(RuntimeError, /1 errors verifying #{klass} conforms to #{interface_module}/)
      end
    end

    context 'when method signatures match' do
      it 'does not raise an error' do
        expect { klass.prepend(interface_module) }.not_to raise_error
      end
    end

    context 'when method signatures do not match' do
      let(:interface_module) { Module.new { |mod| mod::REQUIRED_ATTRIBUTES = [:bar]; def foo(); end }.include described_class }

      it 'raises an error' do
        expect { klass.prepend(interface_module) }.to raise_error(RuntimeError, /1 errors verifying #{klass} conforms to #{interface_module}/)
      end
    end

    context 'when required attributes are implemented' do
      it 'does not raise an error' do
        binding.pry
        expect { klass.prepend(interface_module) }.not_to raise_error
      end
    end

    context 'when required attributes are not implemented' do
      let(:interface_module) { Module.new { |mod| mod::REQUIRED_ATTRIBUTES = [:buzz]; }.include described_class }

      it 'raises an error' do
        expect { klass.prepend(interface_module) }.to raise_error(RuntimeError, /1 errors verifying #{klass} conforms to #{interface_module}/)
      end
    end
  end
end
