require 'active_support/concern'

module Tricle
  module Aggregation
    extend ActiveSupport::Concern

    def days_ago(n)
      start_at = self.now.beginning_of_day.ago(n.days)
      end_at = start_at + 1.day
      self.size_for_range(start_at, end_at)
    end

    def yesterday
      self.days_ago(1)
    end

    def weeks_ago(n)
      start_at = self.now.beginning_of_week.weeks_ago(n)
      end_at = start_at + 7.days
      self.size_for_range(start_at, end_at)
    end

    def last_week
      self.weeks_ago(1)
    end

    def weekly_values(past_num_weeks)
      weeks_range = 1..past_num_weeks
      weeks_range.map{|n| self.weeks_ago(n) }
    end

    def weeks_average(past_num_weeks)
      values = self.weekly_values(past_num_weeks)
      total = values.reduce(0, :+)
      total.to_f / past_num_weeks
    end

    def week_average_this_quarter
      self.weeks_average(13)
    end
  end
end
