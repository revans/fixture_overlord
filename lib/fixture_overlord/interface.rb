# -*- encoding: utf-8 -*-
require 'ostruct'
require 'securerandom'
require_relative "fixture_helper"

# meant to be included within a Hash
module FixtureOverlord
  module Interface
    attr_accessor :yaml_filename

    # return an OpenStruct stand-in to act as a mock
    def mock
      ::OpenStruct.new(self.merge(generate_id))
    end

    # returns the model constant so it can be used for associations:
    # e.g.
    #
    #   @post.replies.new
    #
    #-Create stand ins
    #
    #   new_post  = posts(:new_post).build
    #   reply     = replies(:reply_to_new_post).association
    #
    #-Mock
    #
    #   Post.stubs(:find).returns(new_post)
    #   Post.any_instance.stubs(:replies).returns(reply)
    def association
      build_model_base
    end

    # initialize the model
    def build
      build_model_base.build(self)
    end

    # create in the database
    def create
      build_model_base.create(self)
    end

    # create in the database
    def create!
      build_model_base.create!(self)
    end

    # change a key/value or add one
    def change(options = {})
      self.merge(options)
    end

    # remove hash attributes via their key name
    # e.g.
    #
    #   hash.remove(:email, :password)
    def remove(*keys)
      self.delete_if { |k,_| keys.include?(k) }
    end

    # generate a unique id and return the hash
    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end

    # returns the model constant
    def build_model_base
      @build_model_base ||= FixtureHelper.to_model(yaml_filename)
    end

  end
end
