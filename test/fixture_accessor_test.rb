require 'test_helper'
require './lib/fixture_overlord'

class MiniTest::Unit::TestCase
  include ::FixtureOverlord
  fixture_overlord :rule
end

module FixtureOverlord
  class FixtureAccessorTest < MiniTest::Unit::TestCase

    def test_hash_fixture
      expected = { name: 'Bob', age: 44 }
      assert_equal expected, person(:bob)
    end

  end
end