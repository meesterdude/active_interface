require "spec_helper"
require 'pry'

RSpec.describe ActiveInterface::Contract do

  before do
    stub_const 'TestBase', Class.new {
      def foo(size)
          "Testbase"
      end
  }
    stub_const 'TestClass', Class.new(TestBase) { 
      def foo(size)
        contract = ActiveInterface::Contract.new(binding)
          contract.call do |c|
            c.enforce_input(:size, {})
            c.enforce_output(kind_of: Integer)
          end
      end 
    }
    
  end

  describe "#enforce_input" do
    it "verifies the input value with the given options" do
      allow(Verify).to receive(:call)
      TestClass.new.foo(2)
      expect(Verify).to have_received(:call).with(:size, TestClass, 2, {})
    end
  end

  describe "#enforce_output" do
    it "verifies the output value with the given options" do
      allow(Verify).to receive(:call)
      TestClass.new.foo(2)
      expect(Verify).to have_received(:call).with(:size, TestClass, 2, {})
      expect(Verify).to have_received(:call).with(:output, TestClass, "Testbase", {:kind_of=>Integer})
    end
  end

  describe "#verify" do
    it "calls the Verify class with the given arguments" do
      expect(Verify).to receive(:call).with(:attribute, described_class, "value", {})
      contract = ActiveInterface::Contract.new(binding)
      contract.verify(:attribute, described_class, "value", {})
    end
  end

  describe "#output" do
    it "returns the output from super" do
      contract = ActiveInterface::Contract.new(binding, "output")
      expect(contract.output).to eq("output")
    end
  end
end
