require 'test_helper'
require "./lib/fixture_overlord/hashish"
require "./lib/fixture_overlord/model"

module ActiveRecord
  class Base; end
end

class Person < ActiveRecord::Base
  def initialize(attributes={});  end
  def create;   true; end
  def create!;  true; end
  def build;    true; end

  class << self
    def create(hash = {});   true; end
    def create!(hash = {});  true; end
    def build(hash = {});    true; end
  end
end

module FixtureOverlord
  class ModelTest < Minitest::Test
    def hashish
      @hash ||= begin
        hash = Hashish[{ name: "Bob", age: 49 }].
          symbolize_keys
        hash
      end
    end

    def test_initialization
      model = Model.new(hashish, 'person')
      assert model.can_convert_to_model?
      assert model.respond_to_model_methods?
    end

    def test_converting_to_model
      model   = Model.new(hashish, 'person')
      person  = model.convert_to_model
      assert person

      assert person.respond_to?(:create)
      assert person.respond_to?(:build)
      assert_equal ::ActiveRecord::Base, person.class.superclass
    end

    def test_create_class_method
      assert Model.create(hashish, 'person')
    end

    def test_alias_create_class_method
      assert Model.create!(hashish, 'person')
    end

    def test_init_class_method
      model = Model.init(hashish, 'person')
      assert model
      assert model.create
      assert model.create!
      assert model.build
    end

    def test_plural_filename
      model = Model.init(hashish, 'people')
      assert_equal Person, model.class
      assert model.respond_to?(:create)
      assert model.respond_to?(:build)
      assert_equal ::ActiveRecord::Base, model.class.superclass
    end
  end
end
