require 'minitest/autorun'
require "./lib/fixture_overlord"
require 'rails'

# overried AR with a mock
module ActiveRecord
  class Base < OpenStruct
    class << self
      def create!(hash)
        obj = new(hash)
        obj.id = 1
        obj
      end
      alias :create :create!
    end
  end
end

# setup a mock model
class Game < ActiveRecord::Base; end
class Account < OpenStruct
  def self.create(o)
    "I exist!"
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
      assert_equal "games", game.yaml_filename
      assert game
    end

    def test_mock_fixture
      mock = games(:donkey_kong).mock
      assert_equal "Donkey Kong", mock.name
      assert_equal 123, mock.points
      assert_equal "1st", mock.placement
      assert_equal OpenStruct, mock.class
    end

    def test_build_model_object
      game = games(:donkey_kong).build
      assert_equal "Donkey Kong", game.name
      assert_equal 123, game.points
      assert_equal "1st", game.placement
      assert_equal Game, game.class
    end

    def test_create_model_object
      game = games(:donkey_kong).create
      assert_equal "Donkey Kong", game.name
      assert_equal 123, game.points
      assert_equal "1st", game.placement
      assert_equal Game, game.class
      assert game.id
    end

    def test_association_model_object
      account = account(:account).mock
      game = games(:donkey_kong).associated_with(account).mock

      assert_equal account.id, game.account_id
      # game = games(:donkey_kong).association
      # assert_equal Game, game
    end

    def test_create_bang_model_object
      game = games(:donkey_kong).create!
      assert_equal "Donkey Kong", game.name
      assert_equal 123, game.points
      assert_equal "1st", game.placement
      assert_equal Game, game.class
      assert game.id
    end

    def test_non_activerecord_class
      assert account(:account)
      assert account(:account).build
      assert_equal OpenStruct, account(:account).mock.class
      assert_raises NoMethodError do
        account(:account).create!
      end
      assert_equal "I exist!", account(:account).create
    end

    def test_changing_an_object
      assert_equal "Jumpman Jr.", games(:donkey_kong).change(name: "Jumpman Jr.").mock.name
      assert_equal "Jumpman Jr.", games(:donkey_kong).change(name: "Jumpman Jr.").build.name
      assert_equal "Jumpman Jr.", games(:donkey_kong).change(name: "Jumpman Jr.").create.name
    end

    def test_adding_an_attribute_to_an_object
      assert_equal "Jacob", games(:donkey_kong).add(leader: "Jacob").mock.leader
      assert_equal "Jacob", games(:donkey_kong).add(leader: "Jacob").build.leader
      assert_equal "Jacob", games(:donkey_kong).add(leader: "Jacob").create.leader
    end
  end
end
