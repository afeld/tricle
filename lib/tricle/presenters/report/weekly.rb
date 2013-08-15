require_relative 'base'

module Tricle
  module Presenters
    module Report
      class Weekly < Base
        def weeks_ago(n)
          self.now.beginning_of_week.weeks_ago(n)
        end

        def single_week_dates_cell(start_at)
          dates_cell(start_at, start_at.end_of_week)
        end

        def last_week_dates_cell
          single_week_dates_cell(weeks_ago(1))
        end

        def previous_week_dates_cell
          single_week_dates_cell(weeks_ago(2))
        end

        def quarter_dates_cell
          dates_cell(weeks_ago(13), weeks_ago(1).end_of_week)
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
