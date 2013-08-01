module Tricle
  class Metric

    def initialize
      # TODO allow Time to be passed in so it can be frozen
      @now = Time.now
    end


    def title
      self.class.name.titleize
    end

    def for_range(start_at, end_at)
      raise Tricle::AbstractMethodError.new
    end

    def total
      raise Tricle::AbstractMethodError.new
    end


    def days_ago(n)
      start_at = @now.beginning_of_day.days_ago(n)
      end_at = start_at + 1.day
      self.for_range(start_at, end_at)
    end

    def yesterday
      self.days_ago(1)
    end

    def weeks_ago(n)
      start_at = @now.beginning_of_week.weeks_ago(n)
      end_at = start_at + 7.days
      self.for_range(start_at, end_at)
    end

    def last_week
      self.weeks_ago(1)
    end

    def weeks_average(past_num_weeks)
      weeks_range = 1..past_num_weeks
      total = weeks_range.reduce(0){|sum, n| sum + self.weeks_ago(n) }
      total.to_f / weeks_range.size
    end

    def week_average_this_quarter
      self.weeks_average(13)
    end
  end
end
