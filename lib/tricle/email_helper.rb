module Tricle
  module EmailHelper
    def weeks_ago(n)
      Date.today.beginning_of_week.weeks_ago(n)
    end

    def format_date(date)
      date.strftime('%-m/%-d/%y')
    end

    def number_with_delimiter(number)
      # from http://stackoverflow.com/a/11466770/358804
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end

    def percent_change(new_val, old_val)
      fraction = (new_val - old_val) / old_val.to_f
      sprintf('%+.1f%', fraction * 100.0)
    end

    def dates_str(start_at, end_at)
      "(#{ self.format_date(start_at) } - #{ self.format_date(end_at) })"
    end

    def single_week_date_str(start_at)
      dates_str(start_at, start_at.end_of_week)
    end

    def last_week_dates_str
      single_week_date_str(weeks_ago(1))
    end

    def previous_week_dates_str
      single_week_date_str(weeks_ago(2))
    end

    def quarter_dates_str
      dates_str(weeks_ago(13), weeks_ago(1).end_of_week)
    end
  end
end
