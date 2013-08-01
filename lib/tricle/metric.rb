module Tricle
  class Metric
    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end


    def yesterday
      end_at = Time.now.beginning_of_day
      start_at = end_at - 24.hours
      self.for_range(start_at, end_at)
    end

    def last_week
      end_at = Time.now.beginning_of_week
      start_at = end_at - 1.week
      self.for_range(start_at, end_at)
    end
  end
end
