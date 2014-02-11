require 'test_helper'
require_relative '../lib/fixture_overlord/mock'

module FixtureOverlord
  class MockTest < Minitest::Test
    def mock
      @mock ||= begin
        hash = { name: "Bob", age: 49 }
        Mock.setup(hash)
      end
    end

    def test_initialization
      assert_equal "Bob", mock.name
      assert_equal 49,    mock.age
      assert              mock.id
    end

    def test_to_attributes
      actual = mock.to_attributes
      assert_instance_of Hashish, actual
    end

    def test_change
      mock.change(name: 'Robert')
      assert_equal "Robert", mock.name
    end

    def test_add
      mock.add(address: '123 Street')
      assert_equal "123 Street", mock.address
    end

    def test_merge
      mock.merge(address: '123 Street')
      assert_equal "123 Street", mock.address
    end

    def test_remove
      mock.add(address: '123 Street')
      mock.add(city: 'Carlsbad')
      assert_equal "123 Street",  mock.address
      assert_equal "Carlsbad",    mock.city

      mock.remove(:address)
      assert_nil mock.address

      mock.delete(:city)
      assert_nil mock.city
    end

    def test_child
      post = Mock.setup(title: "Demo", content: "some content")
      blog = Mock.setup(name: "My Blog")

      blog.child(posts: post)

      assert_instance_of Array, blog.posts
      assert_equal "Demo", blog.posts.first.title
    end

    def test_parent
      post = Mock.setup(title: "Demo", content: "some content")
      blog = Mock.setup(name: "My Blog")

      post.parent(blog: blog)
      assert_equal "My Blog", post.blog.name
    end
  end
end
