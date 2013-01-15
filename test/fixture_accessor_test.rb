require 'minitest/autorun'
require "./lib/fixture_overlord"
require 'rails'

# setup a mock model
class Game < Struct.new(:name, :points, :placement)
  def self.create!(hash)
    game = new(*hash)
    game.id = 1
    game
  end
end

# redirect Rails.root to my test/fixture location here
module Rails
  def self.root
    Pathname.new("./")
  end
end

# a stand in ActiveSupport::TestCase from test/test_helper.rb
class MiniTest::Unit::TestCase
  include FixtureOverlord
  fixture_overlord :rule
end

module FixtureOverlord
  class FixtureAccessorTest < MiniTest::Unit::TestCase
    def test_hash_fixture
      expected = {:name=>"Donkey Kong", :points=>123, :placement=>"1st"}
      assert_equal expected, games(:donkey_kong)
    end

    def test_hash
      game = games(:donkey_kong)
      assert game
    end

    def test_mock_fixture
      mock = mock(:donkey_kong)
      # assert_equal "Donkey Kong", mock.name
      # assert_equal 123, mock.points
      # assert_equal "1st", mock.placement
      # assert_equal OpenStruct, mock.class
    end
  end
end
