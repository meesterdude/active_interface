# frozen_string_literal: true

require_relative "lib/active_interface/version"

Gem::Specification.new do |spec|
  spec.name = "active_interface"
  spec.version = ActiveInterface::VERSION
  spec.authors = ["Russell Jennings"]
  spec.email = ["violentpurr@gmail.com"]

  spec.summary = "OOP Interfaces for ruby"
  spec.description = "Provide OOP Interfaces for ruby"
  spec.homepage = "https://github.com/meesterdude/active_interface"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/meesterdude/active_interface"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.2"
spec.add_development_dependency "pry", "~> 0.14"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
