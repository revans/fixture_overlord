require 'ostruct'
require 'securerandom'
require_relative 'helpers'

module FixtureOverlord
  class Mock < OpenStruct

    def self.setup(hash)
      new(hash)
    end

    def initialize(hash)
      super(hash.merge(generate_id))
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
