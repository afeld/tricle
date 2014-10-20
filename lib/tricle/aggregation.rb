require 'active_support/concern'

module Tricle
  module Aggregation
    extend ActiveSupport::Concern

    def periods_ago(period, n)
      case period
      when :day
        start_at = self.now.beginning_of_day.ago(n.days)
        end_at = start_at + 1.day
      when :week
        start_at = self.now.beginning_of_week.ago(n.weeks)
        end_at = start_at + 7.days
      when :month
        start_at = self.now.beginning_of_month.advance(months: -n)
        end_at = start_at.advance(months: 1)
      end

      self.size_for_range(start_at, end_at)
    end

    def range_values(period, num_durations)
      range = num_durations.downto(1)
      range.map do |n|
        self.periods_ago(period, n)
      end
    end

    def range_average(period, past_num_durations)
      values = self.range_values(period, past_num_durations)
      total = values.reduce(0, :+)
      total.to_f / past_num_durations
    end
  end
end
