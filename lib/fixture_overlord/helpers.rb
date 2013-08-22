# -*- encoding: utf-8 -*-
require 'ostruct'
require 'securerandom'

# TODO: refactor to a class
module FixtureOverlord
  module Helpers
    extend self

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
    #
    # TODO: Add more than just ActiveRecord, specifically Sequel
    #
    def persisted_model?(file)
      model = to_model(file)
      model.respond_to?(:superclass) && model.superclass == ::ActiveRecord::Base
    end

    def respond_to_model_methods?(model)
      model.respond_to?(:create!) || model.respond_to?(:create) || model.respond_to?(:build)
    end

  end
end
