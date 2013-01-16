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
  def test_valid_attributes
    refute_valid games(:tron).merge(name: nil).build
  end

  def test_mock_game
    mock = games(:tron).change(name: '').mock
    assert_equal '', mock.name
  end

  def test_missing_attributes
    refute games(:tron).remove(:name).build.valid?
  end

  test "creating an entry in the database" do
    assert_difference "Game.count", 1 do
      games(:tron).create! # or games(:tron).create
    end
  end

  test "use a hash that has symbolized keys" do
    assert games(:tron)
  end
end
```
