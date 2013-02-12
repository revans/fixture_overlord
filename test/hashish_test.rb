require "./lib/fixture_overlord/hashish"
require 'minitest/autorun'
require 'yaml'

module FixtureOverlord
  class HashishTest < MiniTest::Unit::TestCase
    def hashish
      Hashish[name: 'Frank Sinatra', location: 'Vegas', show: true]
    end

    def test_hash_single
      hash = Hashish[when: "Today"]
      expected = {when: "Today"}
      assert_equal expected, hash
    end

    def test_hash_with_odd
      expected = { name: 'Frank Sinatra', location: 'Vegas', show: true }

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

    def test_symbolizing_key_loading_yml
      account = "./test/fixtures/account.yml"

      data = ::YAML.load(IO.read(account))
      expected = {"account"=>{"name"=>"Mandolin Bay", "balance"=>45843.0}}
      assert_equal expected, data

      expected = {:account=>{:name=>"Mandolin Bay", :balance=>45843.0}}
      assert_equal expected, Hashish[expected].symbolize_keys


      fixture   = data["account"]
      expected  = { name: "Mandolin Bay", balance: 45843.00 }
      assert_equal expected, Hashish[expected].symbolize_keys

    end
  end
end
