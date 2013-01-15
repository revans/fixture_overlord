# -*- encoding: utf-8 -*-
require 'ostruct'
require 'securerandom'
require_relative 'hashish'
require_relative "read_fixture"

module FixtureOverlord
  module FixtureAccessor

    # this is what gets dropped into test/test_helper.rb or spec/spec_helper.rb
    # file. It defines methods named after the fixture files names, which are
    # named after your models, but their pluralized.
    #
    # You also get a few more methods that you can use because those model
    # names:
    #
    #   mock, create, build
    #
    # TODO: only supporting the loading of a single object. Will add array
    # support soon.
    #
    def fixture_overlord(setting = nil)
      return unless setting.to_sym == :rule
      yaml_files.each do |yaml|

        # creates the hash version of the model
        define_method( yaml_filename(yaml) ) do |key|
          # read_fixture_file(yaml, key)
          ::FixtureOverlord::ReadFixture.new(yaml).read(key)
        end

        # creates an OpenStruct mock to be used as a stand-in for your Model
        define_method(:mock) do |key|
          # hash = read_fixture_file(yaml, key)
          hash = ::FixtureOverlord::ReadFixture.new(yaml).read(key)
          mock(hash) # TODO: probably move to an interface singleton module
        end

        # these are only available if the model is inherited from ActiveRecord
        if persisted_model?(yaml)

          # persists the model object
          define_method(:create) do |key|
            hash = read_fixture_file(yaml, key)
            model = to_model(yaml)
            model.create!(hash)
          end

          # creates an unsaved version of your model object
          define_method(:build) do |key|
            hash = read_fixture_file(yaml, key)
            model = to_model(yaml)
            model.new(hash)
          end
        end

      end
    end

    private
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
      yaml_filename(file).classify
    end

    # check to see if the model is inherited from ActiveRecord
    def persisted_model?(file)
      model = to_model(file)
      model.respond_to?(:superclass) && model.superclass == ActiveRecord::Base
    end

    # return an OpenStruct stand-in to act as a mock
    def mock(hash)
      ::OpenStruct.new(hash.merge(generate_id))
    end

    def generate_id
      { id: ::SecureRandom.random_number(99999) }
    end
  end
end
