require 'active_support/concern'

module Tricle
  module Aggregation
    extend ActiveSupport::Concern

    def days_ago(n)
      start_at = self.now.beginning_of_day.ago(n.days)
      end_at = start_at + 1.day
      self.size_for_range(start_at, end_at)
    end

    def weeks_ago(n)
      start_at = self.now.beginning_of_week.ago(n.weeks)
      end_at = start_at + 7.days
      self.size_for_range(start_at, end_at)
    end

    def months_ago(n)
      start_at = self.now.beginning_of_month.ago(n.months)
      end_at = start_at + 1.month
      self.size_for_range(start_at, end_at)
    end

    def yesterday
      self.days_ago(1)
    end

    def last_week
      self.weeks_ago(1)
    end

    def last_month
      self.months_ago(1)
    end

    def daily_values(past_num_days)
      days_range = past_num_days.downto(1)
      days_range.map{|n| self.days_ago(n) }
    end

    def weekly_values(past_num_weeks)
      weeks_range = past_num_weeks.downto(1)
      weeks_range.map{|n| self.weeks_ago(n) }
    end

    def monthly_values(past_num_months)
      months_range = past_num_months.downto(1)
      months_range.map{|n| self.months_ago(n) }
    end

    def days_average(past_num_days)
      values = self.daily_values(past_num_days)
      total = values.reduce(0, :+)
      total.to_f / past_num_days
    end

    def weeks_average(past_num_weeks)
      values = self.weekly_values(past_num_weeks)
      total = values.reduce(0, :+)
      total.to_f / past_num_weeks
    end

    def months_average(past_num_months)
      values = self.monthly_values(past_num_months)
      total = values.reduce(0, :+)
      total.to_f / past_num_months
    end

    def day_average_this_week
      self.days_average(7)
    end

    def week_average_this_quarter
      self.weeks_average(13)
    end

    def month_average_this_year
      self.months_average(12)
    end
  end
end
