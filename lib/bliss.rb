require 'bliss/version'
require 'binding_of_caller'

module Kernel
  def bless(object, klass = nil)
    context = binding.of_caller(1)
    klass ||= context.eval('self.class')
    klass.new
  end
end
