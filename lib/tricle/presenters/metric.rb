require_relative 'helper'

module Tricle
  module Presenters
    class Metric
      attr_reader :metric, :now

      def initialize(klass, now)
        @metric = klass.new
        @now = now
      end

      def title
        self.metric.title
      end

      def total
        self.metric.total
      end

      def days_ago(n)
        start_at = self.now.beginning_of_day.days_ago(n)
        end_at = start_at + 1.day
        self.metric.size_for_range(start_at, end_at)
      end

      def yesterday
        self.days_ago(1)
      end

      def weeks_ago(n)
        start_at = self.now.beginning_of_week.weeks_ago(n)
        end_at = start_at + 7.days
        self.metric.size_for_range(start_at, end_at)
      end

      def last_week
        self.weeks_ago(1)
      end

      def weeks_average(past_num_weeks)
        weeks_range = 1..past_num_weeks
        total = weeks_range.reduce(0){|sum, n| sum + self.weeks_ago(n) }
        total.to_f / past_num_weeks
      end

      def week_average_this_quarter
        self.weeks_average(13)
      end


      def title_cell
        %[<th class="metric-title">#{self.title}</th>]
      end

      def last_week_cell
        last_week_formatted = Tricle::Presenters::Helper.number_with_delimiter(self.last_week)
        total_formatted = Tricle::Presenters::Helper.number_with_delimiter(self.total)

        <<-MARKUP
          <td>
            <div>#{last_week_formatted}</div>
            <div>#{total_formatted} (total)</div>
          </td>
        MARKUP
      end

      def previous_week_cell
        Tricle::Presenters::Helper.percent_change_cell(self.last_week, self.weeks_ago(2))
      end

      def quarterly_average_cell
        Tricle::Presenters::Helper.percent_change_cell(self.last_week, self.week_average_this_quarter)
      end

      def cells
        [
          self.title_cell,
          self.last_week_cell,
          self.previous_week_cell,
          self.quarterly_average_cell
        ]
      end
    end
  end
end
