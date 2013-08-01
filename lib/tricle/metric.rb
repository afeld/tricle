module Tricle
  class Metric
    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end
  end
end
