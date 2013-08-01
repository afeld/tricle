module Tricle
  class Metric
    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end


    def days_ago(n)
      start_at = Time.now.beginning_of_day.days_ago(n)
      end_at = start_at + 1.day
      self.for_range(start_at, end_at)
    end

    def yesterday
      self.days_ago(1)
    end

    def weeks_ago(n)
      start_at = Time.now.beginning_of_week.weeks_ago(n)
      end_at = start_at + 7.days
      self.for_range(start_at, end_at)
    end

    def last_week
      self.weeks_ago(1)
    end
  end
end
