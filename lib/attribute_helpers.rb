require "attribute_helpers/version"

# Provides helper functionality for ruby classes that store various
# database-unfriendly types as instance variables. It automatically serializes
# and deserializes things like classes and symbols to interact easily with both
# the database and your application code.

module AttributeHelpers
  # This module needs to be prepended to work in ActiveRecord classes. This is
  # because ActiveRecord doesn't have accessors/mutators defined until an
  # instance is created, which means we need to use the prepend + super()
  # pattern because attempts to use instance_method + binding will fail since
  # instance_method will not find the method in the class context as it will not
  # exist until it is dynamically created when an instance is created. Prepend
  # works for us because it inserts the behavior *below* the class in the
  # inheritance hierarchy, so we can access the default ActiveRecord accessors/
  # mutators through the use of super().
  # More information here: http://stackoverflow.com/a/4471202/1103543
  def self.prepended(klass)
    # We need to store the module in a variable for use when we're in the class
    # context.
    me = self

    # Marks attributes as storing symbol values, providing setters and getters
    # for the attributes that will allow the application to use them as symbols
    # but store them internally as strings.
    # @param attrs [*Symbol] a list of the attributes that store symbols
    klass.define_singleton_method :attr_symbol do |*attrs|
      # Overwrite each attribute's methods.
      attrs.each do |attr|
        # Overwrite the accessor.
        me.send(:define_method, attr) do
          val = super()
          val && val.to_sym
        end

        # Overwrite the mutator.
        me.send(:define_method, "#{attr}=") do |val|
          super(val && val.to_s)
        end
      end
    end

    # Marks attributes as storing class values, providing setters and getters
    # for the attributes that will allow the application to use them as classes
    # but store them internally as strings.
    # @param attrs [*Symbol] a list of the attributes that store classes
    klass.define_singleton_method :attr_class do |*attrs|
      # Overwrite each attribute's methods.
      attrs.each do |attr|
        # Overwrite the accessor.
        # @raise [NameError] if the string can't be constantized
        me.send(:define_method, attr) do
          val = super()
          val && Kernel.const_get(val)
        end

        # Overwrite the mutator.
        me.send(:define_method, "#{attr}=") do |val|
          super(val && val.to_s)
        end
      end
    end
  end
end
