# frozen_string_literal: true

require_relative "active_interface/version"

require_relative "active_interface/base"
require_relative "active_interface/contract"
require_relative "active_interface/interface_error"
require_relative "active_interface/verify"

module ActiveInterface
  class Error < StandardError; end
  # Your code goes here...
end
