module Tricle
  module Helpers
    module EmailHelper
      def beginning_of_week
        Date.today.beginning_of_week
      end

      def format_date(date)
        date.strftime('%-m/%-d/%y')
      end
    end
  end
end
