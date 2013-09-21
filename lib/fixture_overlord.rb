require 'ostruct'
require 'yaml'
require 'securerandom'
require 'erb'

class String
  def classify
    self.gsub(/(_|-)/, ' ').
      split(' ').each do |word|
      word.capitalize!
    end.join
  end

  def constantize
    Object.const_get(self)
  end
end

# require_relative "fixture_overlord/string_extension"
require_relative 'fixture_overlord/fixture_accessor'

module FixtureOverlord
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    include FixtureAccessor
  end
end
