require "attribute_helpers/version"

module AttributeHelpers
  # Makes an attribute a symbol, providing setters and getters for the
  # attr that will translate back and forth as needed
  def attr_symbol(*attrs)
    attrs.each do |attr|
      # Store the original methods for use in the overwritten ones.
      original_getter = instance_method(attr)
      original_setter = instance_method("#{attr}=")

      # Overwrite the accessor.
      define_method attr do
        val = original_getter.bind(self).call
        val && val.to_sym
      end

      # Overwrite the mutator.
      define_method "#{attr}=" do |val|
        original_setter.bind(self).call(val && val.to_s)
      end
    end
  end

  # Makes an attribute a class, providing setters and getters for the
  # attr that will translate back and forth as needed
  def attr_class(*attrs)
    attrs.each do |attr|
      # Store the original methods for use in the overwritten ones.
      original_getter = instance_method(attr)
      original_setter = instance_method("#{attr}=")

      # Overwrite the accessor.
      define_method attr do
        val = original_getter.bind(self).call
        val && Kernel.const_get(val)
      end

      # Overwrite the mutator.
      define_method "#{attr}=" do |val|
        original_setter.bind(self).call(val && val.to_s)
      end
    end
  end
end
