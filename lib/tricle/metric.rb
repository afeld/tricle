require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require_relative 'abstract_method_error'
require_relative 'aggregation'

module Tricle
  class Metric
    include Aggregation

    attr_reader :now

    def initialize(opts = {})
      # TODO allow Time to be passed in so it can be frozen
      @now = Time.now
      @options = opts
    end

    def better
      @options[:better] || :higher
    end

    def title
      @options[:title] || self.class.name.titleize
    end

    def size_for_range(start_at, end_at)
      self.items_for_range(start_at, end_at).size
    end

    def items_for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total?
      self.respond_to?(:total)
    end
  end
end
