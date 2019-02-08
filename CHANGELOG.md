# Unreleased (`master`)

Drop official support for Ruby 2.3 and below, though these versions may continue
to work.

# 0.1.3

Fix an issue where the same attribute name in multiple classes can result in
modifying the attribute for unwanted classes
[(#14)[https://github.com/panorama-ed/attribute_helpers/pull/14]]

Note that this change requires using `extend` again instead of `prepend`.

# 0.1.2

Use RuboCop for development; no external changes.

# 0.1.1

Simplify code to work for both `ActiveRecord` and generic Ruby classes by using
`prepend` instead of `extend`
[(#12)[https://github.com/panorama-ed/attribute_helpers/pull/12]]

# 0.1.0

The initial release! All basic functionality is in here.
