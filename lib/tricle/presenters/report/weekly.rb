require_relative 'base'
require_relative '../helper'

module Tricle
  module Presenters
    module Report
      class Weekly < Base
        def headers
          [
            self.title_header,
            self.last_week_header,
            self.previous_week_header,
            self.quarterly_average_header
          ]
        end

        def title_header
          ''
        end

        def weeks_ago(n)
          self.now.beginning_of_week.weeks_ago(n)
        end

        def single_week_dates_cell(start_at)
          Tricle::Presenters::Helper.dates_cell(start_at, start_at.end_of_week)
        end

        def last_week_dates_range
          single_week_dates_cell(weeks_ago(1))
        end

        def last_week_header
          "<div>Last week</div>#{self.last_week_dates_range}"
        end

        def previous_week_dates_range
          single_week_dates_cell(weeks_ago(2))
        end

        def previous_week_header
          "<div>Previous week</div>#{self.previous_week_dates_range}"
        end

        def quarter_dates_range
          Tricle::Presenters::Helper.dates_cell(weeks_ago(13), weeks_ago(1).end_of_week)
        end

        def quarterly_average_header
          "<div>Quarterly average</div>#{self.quarter_dates_range}"
        end

        def list_markup(list)
          start_at = self.weeks_ago(1).to_time
          end_at = start_at + 7.days
          list.items_markup(start_at, end_at).html_safe
        end
      end
    end
  end
end
