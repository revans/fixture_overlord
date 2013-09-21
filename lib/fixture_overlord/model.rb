module FixtureOverlord
  class Model

    class << self
      def init(hash, filename)
        new(hash, filename).convert_to_model
      end

      def create(hash, filename)
        init(hash, filename).create
      end
      alias_method :create!, :create
    end


    def initialize(hash, filename)
      @hash, @filename = hash, filename
    end

    def convert_to_model
      model_name.new(
        @hash.delete_if { |key,value| key.to_sym == :id }
      )
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
  end
end
