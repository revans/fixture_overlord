require 'minitest/autorun'
require "./lib/fixture_overlord/read_fixture"
require "date"

module FixtureOverlord
  class ReadFixtureTest < MiniTest::Unit::TestCase
    def test_read_valid_yaml
      fixture   = ReadFixture.new("./test/fixtures/account.yml")
      expected  = { name: "Mandolin Bay", balance: 45843.00 }

      account = fixture.read(:account)
      assert_equal expected, account
      assert_equal OpenStruct, account.mock.class
    end

    def test_read_valid_yaml_erb
      fixture   = ReadFixture.new("./test/fixtures/hotel.yml")
      expected  = { id: 10, name: "Mandolin Bay", location: "Vegas Strip",
                    phone: "1-800-999-9999", open: true, date: Date.today }

      hotel = fixture.read(:hotel)
      assert_equal expected,    hotel
      assert_equal OpenStruct,  hotel.mock.class
    end

    def test_read_invalid_yaml
      assert_raises FormattingError do
        ReadFixture.new("./test/invalid.yml").read
      end
    end

  end
end
