require 'minitest/autorun'
require "./lib/fixture_overlord/version"

class VersionTest < MiniTest::Unit::TestCase
  def test_version_number
    assert_match /\d\.\d\.\d/, FixtureOverlord.version
  end
end
