require 'ostruct'
require_relative 'mock'

# Hashish
#
# === About
#
# Hashish is an over-glorified Hash with a few extra special methods to make it easier
# to work with within FixtureOverlord. Things like +symbolize_keys+, which does a deep
# symbolization on all keys within the given hash help create a predictable hash to work
# with.
#
# TODO: #yaml_file - check to see where this is being used. Potentially a relic from before
#       the rewrite.
#
module FixtureOverlord
  class Hashish < ::Hash

    def yaml_file=(name)
      @yaml_file = name
    end

    def mock
      Mock.setup(self)
    end

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
