require 'bliss'

class SomePackage
end

class ParentObject
  attr_accessor :child
end

describe 'Kernel#bless' do
  it 'can bless an object' do
    expected_class = SomePackage
    some_object = bless Object.new, expected_class
    some_object.should be_an_instance_of(expected_class)
  end

  it 'can bless a nested object' do
    expected_class = SomePackage
    parent = ParentObject.new
    parent.child = :unchanged_child_object
    bless parent.child, expected_class
    parent.child.should be_an_instance_of(expected_class)
  end

  it 'can bless an instance variable' do
    expected_class = SomePackage
    @some_instance_variable = :unchanged_instance_variable
    bless @some_instance_variable, expected_class
    @some_instance_variable.should be_an_instance_of(expected_class)
  end

  it 'defaults to the current class' do
    some_object = bless Object.new
    expected_class = self.class
    # the matcher 'be_an_instance_of' uses the 'describe' description
    some_object.instance_of?(expected_class).should be_true
  end

  it 'changes the reference to the object without requiring assignment' do
    some_object = :unchanged_object
    expected_class = SomePackage
    bless some_object, expected_class

    some_object.should be_an_instance_of(expected_class)
  end

  it 'changes the reference to the object when using an implicit class' do
    some_object = String.new
    expected_class = self.class
    bless some_object

    some_object.instance_of?(expected_class).should be_true
  end

  it 'attempts to convert the object if possible' do
    some_object = 15
    expected = [15]
    bless some_object, Array

    some_object.should == expected
  end

  class VeryBasic < BasicObject
    def bless_me(klass)
      ::Kernel.bless self, klass
    end
  end

  it 'gracefully handles BasicObjects' do
    expect {
      VeryBasic.new.bless_me(Hash)
    }.to raise_error(Bliss::Blesser::CannotBlessSimpletons)
  end
end

#describe 'Kernel.my' do
#  it 'unsets the global variable'
#
#  it 'sets a local variable with the same name as the global variable'
#
#  it 'handles multiple variables'
#
#end
