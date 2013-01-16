# FixtureOverlord

* This is an Alpha version and is currently under heavy development.

[![Build Status](https://travis-ci.org/revans/fixture_overlord.png)](https://travis-ci.org/revans/fixture_overlord)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/revans/fixture_overlord)

## Usage

### Setup

```ruby
require 'minitest/autorun'

class MiniTest::Unit::TestCase
  # include FixtureOverlord's Mixin
  include FixtureOverlord

  # add the fixture accessor that will define 1 method for each YAML file
  # within {spec,test}/fixtures.
  fixture_overloard :rule # set to :off to not define methods
end

# in an actual test file
class GameTest < MiniTest::Unit::TestCase

  # build will initialize the model (in this case Game)
  # e.g.
  #   Game.new(...)
  #
  def test_valid_attributes
    refute_valid games(:tron).merge(name: nil).build
  end

  # changes name value to an empty string
  # this is an alias to the merge method for e hash
  #
  # mock will create an OpenStruct Class with accessors
  # to reference the data.
  #
  # e.g.
  #   OpenStruct.new(hashed_version_of_yaml_file)
  #
  def test_mock_game
    mock = games(:tron).change(name: '').mock
    assert_equal '', mock.name
  end

  # removes the key and value for the key named "name"
  def test_missing_attributes
    refute games(:tron).remove(:name).build.valid?
  end

  # create is executed on the model class, in this case Game
  # e.g
  #   Game.create(...)
  #
  test "creating an entry in the database" do
    assert_difference "Game.count", 1 do
      games(:tron).create! # or games(:tron).create
    end
  end

  # creates a hash
  test "use a hash that has symbolized keys" do
    assert games(:tron)
  end
end
```
