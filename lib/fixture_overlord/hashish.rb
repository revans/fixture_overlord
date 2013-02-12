# -*- encoding: utf-8 -*-
require 'ostruct'
require_relative "interface"

module FixtureOverlord
  class Hashish < ::Hash
    include Interface

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
        result[key.to_sym] = nval
        result
      end
    end
  end
end
