require 'minitest/autorun'
require "./lib/fixture_overlord"
require 'rails'

# overried AR with a mock
module ActiveRecord
  class Base < OpenStruct
    def self.create!(hash)
      obj = new(hash)
      obj.id = 1
      obj
    end
  end
end

# setup a mock model
class Game < ActiveRecord::Base; end
class Account < OpenStruct; end

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
      assert_equal "Donkey Kong", mock.name
      assert_equal 123, mock.points
      assert_equal "1st", mock.placement
      assert_equal OpenStruct, mock.class
    end

    def test_build_model_object
      game = build(:donkey_kong)
      assert_equal "Donkey Kong", game.name
      assert_equal 123, game.points
      assert_equal "1st", game.placement
      assert_equal Game, game.class
    end

    def test_create_model_object
      game = create(:donkey_kong)
      assert_equal "Donkey Kong", game.name
      assert_equal 123, game.points
      assert_equal "1st", game.placement
      assert_equal Game, game.class
      assert game.id
    end

    def test_non_activerecord_class
      assert account(:account)
      assert mock(:account)
    end
  end
end
