require 'bless/version'
require 'binding_of_caller'

module Bless
  class Blesser
    class CannotBlessSimpletons < StandardError; end

    def self.bless(object, klass, context, invoker)
      assert_kernel_ancestor_on(object)
      new(object, klass, context, invoker).bless
    end

    def bless
      if blessee_writeable?
        convert_or_set_blessee_in_context
      else
        convert_or_instantiate
      end
    end

    private

    attr_reader :blessee, :blessee_code, :blessee_owner, :code, :context, :invoker, :klass, :object

    def initialize(object, klass, context, invoker)
      @object = object
      @context = context
      @invoker = invoker
      @klass = determine_target_class(klass)
      @code = code_for_invoker
      @blessee_code = extract_blessee_code
      @blessee, @blessee_owner = blessee_and_owner
    end

    def self.assert_kernel_ancestor_on(object)
      object.class.ancestors.include?(Kernel)
    rescue NoMethodError => e
      raise CannotBlessSimpletons.new
    end

    def determine_target_class(klass)
      klass || context.eval('self.class')
    end

    def code_for_invoker
      file, line = invoker.split(':')
      IO.readlines(file)[line.to_i - 1].strip
    end

    def extract_blessee_code
      match_data = code.match code_regex
      match_data[:var] if match_data
    end

    def code_regex
      /
        bless
        (\(\s*|\s+)     # optional opening parens followed by optional whitespace OR mandatory whitespace
        (?<var>[^,\s]+) # extract variable name
        (\s*,\s*.+)?    # optional whitespace, comma, optional whitespace, whatever (all optional)
        \)?             # optional closing parens
      /x
    end

    def blessee_and_owner
      blessee_elements = blessee_code.split('.')
      [blessee_elements.pop, blessee_elements.join('.')]
    end

    def convertable_object?
      Kernel.methods.include?(klass.name.to_sym)
    end

    def convert_or_set_blessee_in_context
      if convertable_object?
        convert_blessee_in_context
      else
        set_blessee_in_context
      end
    end

    def convert_blessee_in_context
      context.eval("#{blessee_code} = send('#{klass.name}', #{blessee_code})")
    end

    def set_blessee_in_context
      context.eval("#{blessee_code} = #{klass}.new")
    end

    def convert_or_instantiate
      if convertable_object?
        send(klass.name, object)
      else
        klass.new
      end
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

    Bless::Blesser.bless(object, klass, context, invoker)
  end
end
