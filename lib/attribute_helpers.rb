require "attribute_helpers/version"

# Provides helper functionality for ruby classes that store various
# database-unfriendly types as instance variables. It automatically serializes
# and deserializes things like classes and symbols to interact easily with both
# the database and your application code.

module AttributeHelpers
  # Marks attributes as storing symbol values, providing setters and getters for
  # the attributes that will allow the application to use them as a symbols but
  # store them internally as strings.
  # @param attrs [*Symbol] a list of the names of attributes that store symbols
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

  # Marks attributes as storing class values, providing setters and getters for
  # the attributes that will allow the application to use them as a classes but
  # store them internally as strings.
  # @param attrs [*Symbol] a list of the names of attributes that store classes
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
