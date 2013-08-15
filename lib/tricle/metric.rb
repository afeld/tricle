require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'

module Tricle
  class Metric
    def title
      self.class.name.titleize
    end

    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end
  end
end
