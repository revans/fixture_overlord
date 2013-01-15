# -*- encoding: utf-8 -*-
require_relative "fixture_overlord/version"
require_relative "fixture_overlord/fixture_accessor"

module FixtureOverlord
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    include FixtureAccessor
  end
end
