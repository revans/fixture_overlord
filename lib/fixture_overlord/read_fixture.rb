require_relative 'hashish'
require 'yaml'
require 'erb'

module FixtureOverlord
  FormattingError = Class.new(StandardError)

  def self.read_fixture(yaml_file, key)
    ReadFixture.new(yaml_file).read(key)
  end

  class ReadFixture
    def initialize(file)
      @file = file
    end

    def read(key = nil)
      hash = read_file
      hash = hash[key.to_s] unless key.nil?
      Hashish[hash].symbolize_keys
    end

    private

    # CREDIT: The next three methods are almost identitical to those within Rails' 
    #         ActiveRecord FixtureSet::File
    #
    # https://github.com/rails/rails/blob/master/activerecord/lib/active_record/fixture_set/file.rb
    #
    def read_file
      begin
        data = ::YAML.load(render)
      rescue ::ArgumentError, ::Psych::SyntaxError => error
        raise FormattingError, "a YAML error ocurred parsing #{@file}.\nThe error was:\n #{error.class}: #{error}", error.backtrace
      end
      validate(data)
    end

    def validate(data)
      unless valid_data?(data)
        raise FormattingError, "fixture is not a Hash or YAML::Omap."
      end

      raise FormattingError unless data.all? { |name, row| ::Hash === row }
      data
    end

    def render
      erb_render(
        IO.read(@file)
      )
    end

    def erb_render(content)
      ::ERB.new(content).result
    end

    def valid_data?(data)
      ::Hash === data || ::YAML::Omap === data
    end
  end
end
