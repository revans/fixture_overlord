# -*- encoding: utf-8 -*-
require_relative 'fixture_helper'

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
      FixtureHelper.yaml_files.each do |yaml|

        # creates the hash version of the model
        define_method( FixtureHelper.yaml_filename(yaml) ) do |key|
          FixtureHelper.read_fixture_file(yaml, key)
        end

        # creates an OpenStruct mock to be used as a stand-in for your Model
        define_method(:mock) do |key|
          hash = FixtureHelper.read_fixture_file(yaml, key)
          FixtureHelper.create_mock(hash)
        end

        # these are only available if the model is inherited from ActiveRecord
        if FixtureHelper.persisted_model?(yaml)

          # persists the model object
          define_method(:create) do |key|
            hash = FixtureHelper.read_fixture_file(yaml, key)
            model = FixtureHelper.to_model(yaml)
            model.create!(hash)
          end

          # creates an unsaved version of your model object
          define_method(:build) do |key|
            hash = FixtureHelper.read_fixture_file(yaml, key)
            model = FixtureHelper.to_model(yaml)
            model.new(hash)
          end
        end

      end
    end
  end
end
