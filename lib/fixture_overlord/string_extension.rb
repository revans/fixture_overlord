
class String
  def classify
    if defined?(ActiveSupport::Inflector)
      ActiveSupport::Inflector.classify(self)
    else
      self.gsub(/(_|-)/, ' ').
        split(' ').each do |word|
        word.capitalize!
      end.join
    end
  end

  def constantize
    if defined?(ActiveSupport::Inflector)
      ActiveSupport::Inflector.constantize(self)
    else
      Object.const_get(self)
    end
  end

  def singularize
    if defined?(ActiveSupport::Inflector)
      ActiveSupport::Inflector.singularize(self, :en)
    else
      self
    end
  end
end