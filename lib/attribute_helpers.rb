require "attribute_helpers/version"

# Provides helper functionality for ruby classes that store various
# database-unfriendly types as instance variables. It automatically serializes
# and deserializes things like classes and symbols to interact easily with both
# the database and your application code.

module AttributeHelpers
  def attr_symbol(*attrs)
    translator = Module.new do
      attrs.each do |attr|
        # Overwrite the accessor.
        define_method(attr) do
          val = super()
          val && val.to_sym
        end

        # Overwrite the mutator.
        define_method("#{attr}=") do |val|
          super(val && val.to_s)
        end
      end
    end

    prepend translator
  end

  def attr_class(*attrs)
    translator = Module.new do
      attrs.each do |attr|
        # Overwrite the accessor.
        define_method(attr) do
          val = super()
          val && Kernel.const_get(val)
        end

        # Overwrite the mutator.
        define_method("#{attr}=") do |val|
          super(val && val.to_s)
        end
      end
    end

    prepend translator
  end
end
