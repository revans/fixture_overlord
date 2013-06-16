require 'test_helper'
require './lib/fixture_overlord/read_fixture'

module FixtureOverlord
  class ReadFixtureTest < Minitest::Test
    def fixture(name)
      ReadFixture.new("./test/fixtures/#{name}")
    end

    def valid_fixture
      @valid_fixture ||= fixture("person.yaml").read(:bob)
    end

    def invalid_fixture
      @invalid_fixture ||= fixture("error.yaml").read(:error)
    end

    def test_read_valid_yaml
      expected = {:name=>"Bob", :age=>44}
      assert_equal expected, valid_fixture
    end

    def test_read_invalid_yaml
      assert_raises FormattingError do
        invalid_fixture
      end
    end

    def test_read_valid_yaml_with_erb
      hotel = fixture("hotel.yml").read(:hotel)

      assert hotel
      assert_equal 10, hotel[:id]
      assert_equal "Mandolin Bay", hotel[:name]
      assert_equal "Vegas Strip", hotel[:location]
      assert_equal "1-800-999-9999", hotel[:phone]
      assert hotel[:open]
      assert_equal Date.today, hotel[:date]
    end
  end
end
