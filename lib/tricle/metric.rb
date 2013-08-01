module Tricle
  class Metric
    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end


    def yesterday
      start_at = Date.yesterday.to_time
      end_at = Date.today.to_time
      self.for_range(start_at, end_at)
    end
  end
end
