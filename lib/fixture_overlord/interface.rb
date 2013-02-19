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
      # ::OpenStruct.new(self.merge(generate_id))
      self.merge!(generate_id)
      Struct.new(model.name, *self.keys).new(*self.values)
    end

    #-Define object associations
    #
    # e.g.
    #   new_post  = posts(:new_post).build
    #   reply     = replies(:reply_to_new_post).associated_with(new_post).build
    #
    def associated_with(object)
      model_base = model.new(self)
      case base.class
      when Hash, Hashish
        model_base.merge!(to_association(object))
      when OpenStruct
        model_base.send("#{underscore_class_name(object)}_id".to_sym, object.id)
        model_base.send(underscore_class_name(object), object)

      # assume model object, subclass of active record
      else
        model_base.send("#{underscore_class_name(object)}_id".to_sym, object.id)
      end
      base
    end

    # initialize the model
    def build
      model.new(self)
    end

    # create in the database
    def create
      model.create(self)
    end

    # create in the database
    def create!
      model.create!(self)
    end

    # change a key/value or add one
    #
    # e.g.
    #   games(:donkey_kong).change(name: 'Jumpman Jr.').mock
    #   games(:donkey_kong).add(leader: 'Jacob').mock
    #
    def change(options = {})
      self.merge(options)
    end
    alias :add :change

    # remove hash attributes via their key name
    # e.g.
    #
    #   hash.remove(:email, :password)
    def remove(*keys)
      self.delete_if { |k,_| keys.include?(k) }
    end

    private

    # generate a unique id and return the hash
    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end

    # returns the model constant
    def model
      @model ||= FixtureHelper.to_model(yaml_filename)
    end

    def to_association(obj)
      {"#{underscore_class_name(obj)}_id" => obj.id}
    end

    def underscore_class_name(obj)
      class_name(obj).name.underscore
    end

    def class_name(obj)
      obj.class
    end

  end
end
