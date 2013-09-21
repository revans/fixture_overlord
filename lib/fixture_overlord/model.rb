module FixtureOverlord
  class Model

    class << self
      def init(hash, filename)
        new(hash, filename).new_model_with_values
      end

      def create(hash, filename)
        new(hash, filename).create_as_model
      end
      alias_method :create!, :create
    end

    def initialize(hash, filename)
      @hash, @filename = hash, filename
    end

    def convert_to_model
      model_name.new( sanitize_hash )
    end

    def new_model_with_values
      model_name.new( sanitize_hash )
    end

    def create_as_model
      model_name.create( sanitize_hash )
    end

    def model_name
      @filename.to_s.classify.constantize
    end

    def can_convert_to_model?
      model = model_name
      model.respond_to?(:superclass) &&
        model.superclass == ::ActiveRecord::Base
    end

    def respond_to_model_methods?
      model = convert_to_model
      model.respond_to?(:create!) ||
        model.respond_to?(:create) ||
        model.respond_to?(:build)
    end

    def sanitize_hash
      @hash.delete_if { |key,value| key.to_sym == :id }
    end

  end
end
