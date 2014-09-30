require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require_relative 'abstract_method_error'
require_relative 'aggregation'

module Tricle
  class Metric
    include Aggregation

    attr_reader :now, :options

    def initialize(opts = {})
      @now = Tricle::Time.new(opts[:now])
      @options = opts
    end

    def inspect
      if total?
        print "Total: "
        puts total
      end

      print "Size for last week: "
      puts size_for_range(@now.time - 7.days, @now.time)

      items = begin
        items_for_range(@now.time - 7.days, @now.time)
      rescue Tricle::AbstractMethodError
        nil
      end

      if items
        print "List for last week: "
        items.each do |item|
          puts "- #{item}"
        end
      end

      return
    end

    def better
      options[:better] || :higher
    end

    def title
      options[:title] || self.class.name.titleize
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
