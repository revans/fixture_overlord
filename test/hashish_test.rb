require 'test_helper'
require './lib/fixture_overlord'
require './lib/fixture_overlord/hashish'
require 'ostruct'

module ActiveRecord
  class Base; end
end

class Person < ActiveRecord::Base
  def initialize(attributes={});  end
  class << self
    def create(*args);    true; end
    def create!(*args);   true; end
    def build(*args);     true; end
  end
end

class Minitest::Test
  include ::FixtureOverlord
  fixture_overlord :rule
end


module FixtureOverlord
  class HashishTest < Minitest::Test
    def hash
      @hash ||= { name: 'Bob', age: 44 }
    end

    def bob
      @bob ||= person(:bob)
    end

    def test_mock
      mock = bob.mock
      assert_equal "Bob", mock.name
      assert_equal 44,    mock.age
    end

    def test_model
      model = bob.model
      assert_instance_of Person, model
    end

    def test_create
      assert bob.create
      assert bob.create!
    end

    def test_build
      assert bob.build
    end

  end
end
