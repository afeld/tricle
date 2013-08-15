require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require_relative 'abstract_method_error'

module Tricle
  class Metric
    def title
      self.class.name.titleize
    end

    def size_for_range(start_at, end_at)
      self.items_for_range(start_at, end_at).size
    end

    def total
      raise Tricle::AbstractMethodError.new
    end

    def items_for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end
  end
end
