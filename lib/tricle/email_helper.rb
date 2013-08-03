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

    def percent_change_cell(new_val, old_val)
      cls = (new_val >= old_val) ? 'positive' : 'negative'
      pct_str = percent_change(new_val, old_val)
      %[<td class="#{cls}"><div>#{pct_str}</div><div>#{old_val.round}</div></td>].html_safe
    end

    def dates_range_str(start_at, end_at)
      "#{ self.format_date(start_at) } - #{ self.format_date(end_at) }"
    end

    def dates_cell(start_at, end_at)
      range = dates_range_str(start_at, end_at)
      "<div>(#{range})</div>".html_safe
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
  end
end
