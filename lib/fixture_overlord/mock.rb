require 'ostruct'
require 'securerandom'
require_relative 'helpers'
require_relative 'hashish'

module FixtureOverlord
  class Mock < OpenStruct

    def self.setup(hash)
      new(hash)
    end

    def initialize(hash)
      super(hash.merge(generate_id))
    end

    # Converts attributes back to a hash (Hashish).
    # Beacuse this is still a Hashish Hash, we can covert
    # it back to a mock.
    #
    # ==== Examples
    #
    # e.g.
    #   blog.to_attributes => { title: 'Blog' }
    #
    def to_attributes
      Hashish[self.to_h].symbolize_keys
    end


    # add a child association
    #
    # ==== Examples
    #
    # e.g. (has_many)
    #
    #   blog.child(posts: post)
    #   blog.posts.first.title
    #
    # There are 4 methods aliased to this one to provide
    # the developer ActiveRecord & a Sequel (ORM) like
    # interface.
    #
    def child(options)
      associations(options) do |k,v|
        writer(k,[v])
      end
    end
    alias :has_many     :child
    alias :one_to_many  :child


    # add a parent association
    #
    # ==== Examples
    #
    # e.g. (belongs_to)
    #
    #   post.parent(blog: blog)
    #   post.blog.name
    #
    # There are 4 methods aliased to this one to provide
    # the developer ActiveRecord & a Sequel (ORM) like
    # interface.
    #
    def parent(options)
      associations(options) do |k,v|
        writer(k,v)
      end
    end
    alias :belongs_to   :parent
    alias :many_to_one  :parent
    alias :has_one      :parent
    alias :one_to_one   :parent


    # change a key/value or add one
    #
    # ==== Examples
    #
    # e.g.
    #   games(:donkey_kong).change(name: 'Jumpman Jr.').mock
    #   games(:donkey_kong).add(leader: 'Jacob').mock
    #
    def change(options = {})
      options.each { |k,v| writer(k,v) }
      self
    end
    alias :add :change
    alias :merge :change


    # remove an attribute from the class
    #
    # ==== Examples
    #
    # e.g.
    #   blog.remove(:name)
    #   blog.name == nil
    #
    def remove(key)
      writer(key)
    end
    alias :delete :remove


    private

    # generate a unique id and return the hash
    #
    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end

    # assign a value to a hash key
    #
    def writer(key, value = nil)
      self.send("#{key}=", value)
    end

    def build_model_base
      @build_model_base ||= Helpers.to_model(yaml_filename)
    end

    def associations(options, &block)
      options.each do |k,v|
        v = Mock.setup(v) if v.is_a?(Hash) || v.is_a?(Hashish)
        yield k, v
      end
    end

  end
end
