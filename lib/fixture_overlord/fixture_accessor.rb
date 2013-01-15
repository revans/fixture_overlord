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
        define_method(FixtureHelper.yaml_filename(yaml)) do |key|
          hash = FixtureHelper.read_fixture_file(yaml, key)
          hash.yaml_filename = FixtureHelper.yaml_filename(yaml)
          hash
        end

      end
    end
  end
end
