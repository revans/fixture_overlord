require 'minitest/autorun'
require "./lib/fixture_overlord"

module FixtureOverlord
  class FixtureHelperTest < MiniTest::Unit::TestCase
    def test_create_mock
      hash = {name: 'luke'}
      mock = FixtureHelper.create_mock(hash)
      assert mock
      assert mock.id
      assert_equal 'luke', mock.name
    end
  end
end
