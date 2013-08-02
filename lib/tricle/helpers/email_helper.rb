module Tricle
  module Helpers
    module EmailHelper
      def beginning_of_week
        Date.today.beginning_of_week
      end

      def weeks_ago(n)
        self.beginning_of_week.weeks_ago(n)
      end

      def format_date(date)
        date.strftime('%-m/%-d/%y')
      end

      def percent_change(new_val, old_val)
        fraction = (new_val - old_val) / old_val.to_f
        sprintf('%.1f%', fraction * 100.0)
      end
    end
  end
end
