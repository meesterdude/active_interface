# active_interface

ActiveInterface is a Ruby library for defining "active" OOP interfaces in ruby. 

## Getting Started

Add to your Gemfile

```
  gem 'activeinterface'
```

Then Bundle install. Now create a directory like `app/interfaces` and put your first interface there. 

```
module ExampleInterface  
  extend ActiveInterface::Base

  def example
    super
  end
end
```

Make sure any methods defined either call `super` or define an `InterfaceContract` (more info below) in order for the underlying method to be called. 

for any class that you want to apply this interface to, append it after the definition. This ensures all the methods are defined, and that when the Interface is appended that it will sit in front of the method calls and act as a pass through.   

```
class MyClass
  ...
end
MyClass.append ExampleInterface
```

## What's an OOP interface?

An interfaces allows developers to define an abstract collection of methods and attributes that must be implemented by a class. This allows developers to code against an abstract interface (that many classes could implement) instead of just a specific classes implementation. 

Given the following class
```
class User

  attr_accessor :first_name, :last_name

  def full_name(seperator)
    first_name + seperator + last_name
  end
end
```

if we also want a `Contact` or `Admin` to have the same behavior, we might reach for creating a common `Person` class. But what if each of our Classes already inherit from another class? We could extact everything into a `PersonModule`. But if we also have a `Product` class, or a `Car` class with the same behavior but their own implementations, how can we allow them to be wildly different and yet similar enough to treat the same in certain circumstances? 

Enter Active Interface!

```
module NameInterface
  
  extend ActiveInterface::Base

  REQUIRED_ATTRIBUTES = %i[first_name last_name].freeze

  def full_name(seperator)
    super 
  end

end

User.append NameInterface
```

Once we append `User` with `NameInterface`, we gain the following:
  - Will raise exception if any of the required attributes are not defined
  - Will raise exception if the expected methods are not defined or have different method signatures
  - the interface sits in front of every call to the methods 
  - we can ask `User.interface?(NameInterface) => true` to develop our code against. 

## What's an *active* interface?

Once appended, Active Interface will ensure that certain methods and attributes are present. However, as a dynamically typed language, it can be ambiguious what the expected inputs and outputs are for a method or how flexible they are. As a developer that must rely on an interface created by another developer or team, how can you be sure you'll get the expected return values, or that you know what the expected inputs are? 

Enter Interface Contracts with Active Interface!

```
module NameInterface
  
  extend ActiveInterface::Base

  REQUIRED_ATTRIBUTES = %i[first_name last_name].freeze

  def full_name(seperator)
    InterfaceContract.new(binding).call do |c|
      c.enforce_input :seperator, kind_of: String, length: 1..4
      c.enforce_output kind_of: String
    end
  end
end

User.append NameInterface
```

With the above Interface, every call to `#full_name` will be verified that it adheres to the interface contract. This carries a number of benefits:
- Documentation about what the expected parameters and return values are for the Interface
- method level validations of input and output values abstracted from implementation
- raises `InterfaceError` for any incorrect parameters per the contract
- raises `InterfaceError` if the output does not conform to the contract
- Ensures developers can implement interfaces and code against them reliably
- If there are no exceptions raised, the block returns the result of calling `super`

## Other Active Interface uses
Because of the runtime capabilities, Active Interface can be used for more than just API conformity. Some additional uses could include:

- Logging request/response of method calls. 
- Transforming inputs or outputs (such as always calling `.to_s`)
- Caching
- Running history of previous inputs and outputs


