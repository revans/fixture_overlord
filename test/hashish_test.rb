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

    def test_merge
      bob_extended = bob.merge(occupation: 'Secret Agent').mock
      assert_equal 'Secret Agent', bob_extended.occupation
    end

    def test_remove
      assert bob.key?(:age)
      bob.remove(:age)

      refute bob.key?(:age)
    end

    def test_add
      bob.add(gender: 'male')

      assert bob.key?(:gender)
      assert_equal 'male', bob[:gender]
    end

    def test_change
      bob.add(phone: '987-9876')

      assert bob.key?(:phone)
      assert_equal '987-9876', bob[:phone]
    end

    def test_update
      bob.add(favorites: 'fish & chips')

      assert bob.key?(:favorites)
      assert_equal 'fish & chips', bob[:favorites]
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

    def test_associate
      bob.associate(account_id: 1)
      mock = bob.mock

      assert_equal 1, mock.account_id
    end

  end
end
