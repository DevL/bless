require 'bliss'

class SomePackage
end

describe Bliss do
  it 'can bless an object' do
    some_package = SomePackage
    some_object = bless Object.new, some_package
    some_object.should be_an_instance_of(some_package)
  end

  it 'defaults to the current class' do
    some_object = bless Object.new
    expected_class = self.class
    some_object.instance_of?(expected_class).should be_true # be_an_instance_of returns the describe
  end
end
