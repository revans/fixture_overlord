require 'ostruct'
require_relative 'mock'
require_relative 'model'
require_relative 'helpers'

# Hashish
#
# === About
#
# Hashish is an over-glorified Hash with a few extra special methods to make it easier
# to work with within FixtureOverlord. Things like +symbolize_keys+, which does a deep
# symbolization on all keys within the given hash help create a predictable hash to work
# with.
#
module FixtureOverlord
  class Hashish < ::Hash
    attr_accessor :yaml_file

    def mock
      Mock.setup(self)
    end

    def model
      Model.init(self, yaml_file)
    end

    def create
      Model.create(self, yaml_file)
    end
    alias :create! :create

    def build
      Model.init(self, yaml_file)
    end

    def associate(hash)
      self.merge!(hash)
      self
    end

    def remove(key)
      self.delete_if { |k,_| k.to_s == key.to_s }
    end

    def add(options = {})
      self.merge!(options)
      self
    end
    alias :update :add
    alias :change :add


    def symbolize_keys(hash = self)
      results = case hash
      when Array
        symbolize_array_keys(hash)
      when Hash
        symbolize_hash_keys(hash)
      else
        hash
      end
      Hashish[results]
    end

    private

    def symbolize_array_keys(array)
      array.inject([]) do |result, value|
        result << case value
        when Hash, Array
          symbolize_keys(value)
        else
          value
        end
        result
      end
    end

    def symbolize_hash_keys(hash)
      hash.inject({}) do |result, (key,value)|
        nval = case value
        when Hash, Array
          symbolize_keys(value)
        else
          value
        end
        result[key.downcase.to_sym] = nval
        result
      end
    end
  end
end
