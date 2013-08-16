require_relative '../abstract_method_error'

module Tricle
  class Section
    attr_reader :now

    def initialize(now)
      @now = now
    end

    def title
      raise Tricle::AbstractMethodError.new
    end

    def weeks_ago(n)
      self.now.beginning_of_week.weeks_ago(n)
    end
  end
end
