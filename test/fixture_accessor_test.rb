require 'test_helper'
require './lib/fixture_overlord'

class Minitest::Test
  include ::FixtureOverlord
  fixture_overlord :rule
end

module FixtureOverlord
  class FixtureAccessorTest < Minitest::Test

    def hash
      @hash ||= { name: 'Bob', age: 44 }
    end

    def bob
      @bob ||= person(:bob).mock
    end

    def test_hash_fixture
      assert_equal hash, person(:bob)
    end

    def test_mock_fixture
      assert bob
      assert bob.id
      assert_equal 'Bob', bob.name
      assert_equal 44,    bob.age

      assert_equal hash.merge(id: bob.id), bob.to_attributes
    end

    def test_mock_association
      mobile = phone(:bob_mobile).mock
      shared_mock_association_tests(bob, mobile)
    end

    def test_mock_assocation_when_assocation_is_hash
      mobile = phone(:bob_mobile)
      shared_mock_association_tests(bob, mobile)
    end

    def test_mock_association_belongs_to
      cw = company(:cw).mock
      assert cw.id
      assert cw.name
      assert cw.description

      assert bob.belongs_to(company: cw)
      assert_equal "Code Wranglers", bob.company.name
      assert_equal "Custom Software Development", bob.company.description
    end

    def test_mock_association_belongs_to_when_association_is_hash
      cw = company(:cw)

      assert bob.belongs_to(company: cw)
      assert_equal "Code Wranglers", bob.company.name
      assert_equal "Custom Software Development", bob.company.description
    end

    def test_changing_a_mock_attribute
      cw = company(:cw).mock
      cw.change(name: 'Code Wranglers, Inc.')
      assert_equal "Code Wranglers, Inc.", cw.name

      cw.change(name: 'Code Wranglers - Software Development')
      assert_equal 'Code Wranglers - Software Development', cw.name
    end

    def test_adding_a_new_attribute
      bob.add(gender: 'male')
      assert_equal 'male', bob.gender

      bob.change(gender: 'unicorn')
      assert_equal 'unicorn', bob.gender
    end

    def test_removing_attributes
      bob.remove(:name)
      assert_nil bob.name
    end

    private

    def shared_mock_association_tests(object, assoc)
      assert object.has_many(phones: assoc)

      assert_equal 18001234567, object.phones.first.number
      assert_equal 1,           object.phones.size
      assert_equal "cell",      object.phones.first.type

      assert object.phones.first.id
    end

  end
end
