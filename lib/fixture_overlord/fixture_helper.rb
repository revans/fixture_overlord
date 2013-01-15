# -*- encoding: utf-8 -*-
require 'ostruct'
require 'securerandom'
require_relative "read_fixture"

module FixtureOverlord
  module FixtureHelper
    extend self

    # returns a hash of the specified key found within the given yml file
    def read_fixture_file(yaml, key)
      ::FixtureOverlord::ReadFixture.new(yaml).read(key)
    end

    # glob all yml files from their respective fixtures location
    def yaml_files
      Dir.glob(Rails.root.join("{test,spec}/fixtures/**/*.{yaml,yml}").to_s)
    end

    # reading the yaml filename
    def yaml_filename(file)
      ::File.basename(file).split('.').first.to_sym
    end

    # take the yaml file name and convert it to a model classname
    def to_model(file)
      yaml_filename(file).to_s.classify
    end

    # check to see if the model is inherited from ActiveRecord
    def persisted_model?(file)
      model = to_model(file)
      model.respond_to?(:superclass) && model.superclass == ActiveRecord::Base
    end

    # return an OpenStruct stand-in to act as a mock
    def create_mock(hash)
      ::OpenStruct.new(hash.merge(generate_id))
    end

    # generate a unique id and return the hash
    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end

  end
end
