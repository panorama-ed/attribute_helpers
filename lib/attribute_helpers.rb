require "attribute_helpers/version"

# Provides helper functionality for ruby classes that store various
# database-unfriendly types as instance variables. It automatically serializes
# and deserializes things like classes and symbols to interact easily with both
# the database and your application code.

module AttributeHelpers
  def attr_symbol(*attrs)
    transform_attributes(*attrs, &:to_sym)
  end

  def attr_class(*attrs)
    transform_attributes(*attrs) { |val| Kernel.const_get(val) }
  end

  # Implementation Note
  # -------------------
  # The transformers above all work by creating an anonymous module for each
  # group of attributes that gets prepended into the class the AttributeHelpers
  # module is included into. These modules need to be defined at method call
  # time to avoid leaking the overrided methods into other classes this module
  # is included in.
  #
  # This anonymous module needs to be prepended to work in ActiveRecord classes.
  # This is because ActiveRecord doesn't have accessors/mutators defined until
  # an instance is created, which means we need to use the prepend pattern
  # because attempts to use instance_method instance_method will not find the
  # method in the class context as it will not exist until it is dynamically
  # created when an instance is created. Prepend works for us because it inserts
  # the behavior *below* the class in the inheritance hierarchy, so we can
  # access the default ActiveRecord accessors/ mutators through the use of
  # super().
  #
  # More information here: http://stackoverflow.com/a/4471202/1103543
  def transform_attributes(*attrs, &block)
    transformer = Module.new do
      attrs.each do |attr|
        # Overwrite the accessor.
        define_method(attr) do
          val = super()
          val && block.call(val)
        end

        # Overwrite the mutator.
        define_method("#{attr}=") do |val|
          super(val && val.to_s)
        end
      end
    end

    prepend transformer
  end
end
