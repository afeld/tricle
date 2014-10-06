require_relative 'metric'

module Tricle
  class ActiveRecordMetric < Metric
    def items
      options[:items] || raise(Tricle::AbstractMethodError.new)
    end

    def time_column
      options[:time_column] || 'created_at'
    end

    def unit
      options[:unit] || 'record'
    end

    def size_for_range(start_at, end_at)
      items.where("#{time_column}" => start_at..end_at).count
    end

    def items_for_range(start_at, end_at)
      items.where("#{time_column}" => start_at..end_at)
    end

    def total
      items.count
    end
  end
end
