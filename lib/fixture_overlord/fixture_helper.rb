# -*- encoding: utf-8 -*-
require 'ostruct'
require 'securerandom'
require_relative "read_fixture"

# TODO: refactor to a class
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
      ::File.basename(file).split('.').first
    end

    # take the yaml filename and convert it to a model classname
    def to_model(file)
      model = yaml_filename(file).to_s.classify.constantize
      model
    end

    # check to see if the model is inherited from ActiveRecord
    def persisted_model?(file)
      model = to_model(file)
      model.respond_to?(:superclass) && model.superclass == ActiveRecord::Base
    end

    def respond_to_model_methods?(model)
      model.respond_to?(:create!) || model.respond_to?(:create) || model.respond_to?(:build)
    end

  end
end
