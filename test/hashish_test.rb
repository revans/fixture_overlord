require 'minitest/autorun'
require "./lib/fixture_overlord/hashish"

module FixtureOverlord
  class HashishTest < MiniTest::Unit::TestCase
    def hashish
      Hashish[name: 'Frank Sinatra', location: 'Vegas']
    end

    def test_is_hash
      expected = { name: 'Frank Sinatra', location: 'Vegas' }

      assert_equal expected, hashish
    end

    def test_mock
      mock = hashish.mock

      assert_equal OpenStruct, mock.class
      assert_equal 'Frank Sinatra', mock.name
      assert_equal 'Vegas', mock.location
    end

    def test_symbolizing_keys
      string_hash = Hashish[{ "account" => { "name" => "Mandolin Bay", "location" => "Vegas" } }]
      expected = { account: { name: "Mandolin Bay", location: "Vegas" } }

      assert_equal expected, string_hash.symbolize_keys
      assert_equal OpenStruct, string_hash.symbolize_keys.mock.class
    end
  end
end
