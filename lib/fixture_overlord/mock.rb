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
    # e.g.
    #   blog.to_attributes => { title: 'Blog' }
    #
    def to_attributes
      Hashish[self.to_h]
    end


    # add an association
    #
    # e.g. (has_many)
    #
    #   blog.association(posts: post)
    #   blog.posts.first.title
    #
    #   (belongs_to)
    #
    #   post.association(blog: blog)
    #   post.blog.name
    #
    def association(options)
      options.each { |k,v| writer(k,[v]) }
    end


    # change a key/value or add one
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


    # remove an attribute from the class
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
    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end

    def writer(key, value = nil)
      self.send("#{key}=", value)
    end

    def build_model_base
      @build_model_base ||= Helpers.to_model(yaml_filename)
    end

  end
end