
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
