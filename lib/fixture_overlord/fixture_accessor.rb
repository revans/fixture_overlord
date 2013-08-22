require_relative "read_fixture"
require_relative "helpers"
require 'pathname'

module FixtureOverlord
  module FixtureAccessor
    extend self

    def fixture_overlord(setting = nil)
      return unless setting.to_sym == :rule
      yaml_files.each do |yaml|

        # creates the hash version of the model
        define_method(yaml_filename(yaml)) do |key|
          hash            = FixtureOverlord.read_fixture(yaml, key)
          hash.yaml_file  = Helpers.yaml_filename(yaml)
          hash
        end

      end
    end

    def root
      @root ||= ::Pathname.new(Dir.pwd)
    end

    private

    # glob all yml files from their respective fixtures location
    def yaml_files
      Dir.glob(root.join("{test,spec}/fixtures/**/*.{yaml,yml}").to_s)
    end

    # reading the yaml filename
    def yaml_filename(file)
      ::File.basename(file).split('.').first
    end

  end
end