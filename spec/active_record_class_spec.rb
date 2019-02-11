require "spec_helper"

RSpec.context "in an ActiveRecord class" do
  Temping.create :active_record_test_class do
    with_columns do |t|
      t.integer :other_symbol_attr
      t.integer :other_class_attr
      t.string :symbol_attr
      t.string :class_attr
    end

    extend AttributeHelpers

    attr_symbol :symbol_attr
    attr_class :class_attr
  end

  Temping.create :other_active_record_test_class do
    with_columns do |t|
      t.string :other_symbol_attr
      t.string :other_class_attr
    end

    extend AttributeHelpers

    attr_symbol :other_symbol_attr
    attr_class :other_class_attr
  end

  let(:test_obj) { ActiveRecordTestClass.new }

  describe ".attr_symbol" do
    describe "getter" do
      it "translates string to symbol" do
        # Give it an intial value to be read.
        test_obj[:symbol_attr] = "example"

        expect(test_obj.symbol_attr).to eq :example
      end

      it "reads nil correctly" do
        # Explicitly set the attribute to nil, though it's already nil by
        # default.
        test_obj[:symbol_attr] = nil

        expect(test_obj.symbol_attr).to be_nil
      end
    end

    describe "setter" do
      it "translates symbol to string" do
        test_obj.symbol_attr = :example
        expect(test_obj[:symbol_attr]).to eq "example"
      end

      it "stores nil when nil is passed" do
        # Give it an intial value, to make sure the nil set isn't just relying
        # on default object behavior.
        test_obj.symbol_attr = :example

        test_obj.symbol_attr = nil
        expect(test_obj[:symbol_attr]).to be_nil
      end
    end

    context "with attributes that overlap with another class" do
      it "does not overwrite other attributes" do
        test_obj.other_symbol_attr = 12_345
        expect(test_obj.other_symbol_attr).to eq 12_345
      end
    end
  end

  describe ".attr_class" do
    describe "getter" do
      context "when string represents a real class" do
        it "translates string to class" do
          # Give it an intial value to be read.
          test_obj[:class_attr] = "Object"

          expect(test_obj.class_attr).to eq Object
        end
      end

      context "when string does not represent a real class" do
        it "raises an error" do
          # Give it an intial value to be read.
          test_obj[:class_attr] = "BogusClass"

          expect { test_obj.class_attr }.to raise_error(NameError)
        end
      end

      it "reads nil correctly" do
        # Explicitly set the instance variable to nil, though it's already nil
        # by default.
        test_obj[:class_attr] = nil

        expect(test_obj.class_attr).to be_nil
      end
    end

    describe "setter" do
      it "translates class to string" do
        test_obj.class_attr = Object
        expect(test_obj[:class_attr]).to eq "Object"
      end

      it "stores nil when nil is passed" do
        # Give it an intial value, to make sure the nil set isn't just relying
        # on default object behavior.
        test_obj.class_attr = Object

        test_obj.class_attr = nil
        expect(test_obj[:class_attr]).to be_nil
      end
    end

    context "with attributes that overlap with another class" do
      it "does not overwrite other attributes" do
        test_obj.other_class_attr = 12_345
        expect(test_obj.other_class_attr).to eq 12_345
      end
    end
  end
end
