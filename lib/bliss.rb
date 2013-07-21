require 'bliss/version'
require 'binding_of_caller'

module Bliss
  class Blesser
    class CannotBlessSimpletons < StandardError; end

    def self.bless(object, klass, context, invoker)
      assert_kernel_ancestor_on(object)
      new(object, klass, context, invoker).bless
    end

    def bless
      set_class
    end

    private

    attr_reader :blessee, :blessee_code, :blessee_owner, :code, :context, :invoker, :klass

    def initialize(object, klass, context, invoker)
      @object = object
      @context = context
      @invoker = invoker
      @klass = klass || context.eval('self.class')
      @code = code_for_invoker
      @blessee_code = extract_blessee_code
      @blessee, @blessee_owner = blessee_and_owner
    end

    def self.assert_kernel_ancestor_on(object)
      object.class.ancestors.include?(Kernel)
    rescue NoMethodError => e
      raise CannotBlessSimpletons.new
    end

    def code_for_invoker
      file, line = invoker.split(':')
      IO.readlines(file)[line.to_i - 1].strip
    end

    def extract_blessee_code
      match_data = code.match regex_for_code
      match_data[:var] if match_data
    end

    def regex_for_code
      if code.include?(',')
        /bless\s+(?<var>\S+)\s*,\s*.+/
      else
        /bless\s+(?<var>\S+)/
      end
    end

    def blessee_and_owner
      blessee_elements = blessee_code.split('.')
      [blessee_elements.pop, blessee_elements.join('.')]
    end

    def set_class
      if blessee_writeable?
        if convertable_object?
          convert_blessee_in_context
        else
          set_blessee_in_context
        end
      else
        if convertable_object?
          send(klass.name, object)
        else
          klass.new
        end
      end
    end

    def convertable_object?
      Kernel.methods.include?(klass.name.to_sym)
    end

    def convert_blessee_in_context
      context.eval("#{blessee_code} = send('#{klass.name}', #{blessee_code})")
    end

    def set_blessee_in_context
      context.eval("#{blessee_code} = #{klass}.new")
    end

    def blessee_writeable?
      if !blessee_owner.empty?
        blessee_assignable?
      else
        assignable_variables_for_context.include?(blessee.to_sym)
      end
    end

    def blessee_assignable?
      context.eval "#{blessee_owner}.respond_to?('#{blessee}=')"
    end

    def assignable_variables_for_context
      context.eval('local_variables + instance_variables')
    end
  end
end

module Kernel
  def bless(object, klass = nil)
    context = binding.of_caller(1)
    invoker = caller.first

    Bliss::Blesser.bless(object, klass, context, invoker)
  end
end
