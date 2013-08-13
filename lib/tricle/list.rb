require_relative 'section'

module Tricle
  class List < Section
    attr_reader :metric

    def initialize(klass)
      @metric = klass.new
    end

    def title
      self.metric.title
    end

    def items
      self.metric.items
    end
  end
end
