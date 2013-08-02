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

      def fraction(numerator, denominator)
        sprintf('%.1f%', (numerator / denominator.to_f) * 100.0)
      end
    end
  end
end
