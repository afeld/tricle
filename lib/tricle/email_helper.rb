require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require 'sparklines'

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
      if old_val == 0
        new_val >= 0 ? '+' : '-'
      else
        fraction = (new_val - old_val) / old_val.to_f
        sprintf('%+.1f%', fraction * 100.0)
      end
    end

    def percent_change_cell(new_val, old_val)
      cls = (new_val >= old_val) ? 'positive' : 'negative'
      pct_str = percent_change(new_val, old_val)
      old_val_str = number_with_delimiter(old_val.round)
      %[<td class="#{cls}"><div>#{pct_str}</div><div>#{old_val_str}</div></td>].html_safe
    end

    def dates_range_str(start_at, end_at)
      "#{ self.format_date(start_at) } - #{ self.format_date(end_at) }"
    end

    def dates_cell(start_at, end_at)
      range = dates_range_str(start_at, end_at)
      %[<div class="date-range">(#{range})</div>].html_safe
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

    def sparkline(metric)
      # http://bit.ly/1qnR55Y
      values = metric.weekly_values(13)
      blob = Sparklines.plot(values,
        dot_size: 4,
        height: 30,
        line_color: '#4A8FED',
        step: 30
      )
      attachment_title = "#{metric.title.underscore}.png"
      attachments.inline[attachment_title] = blob
      attachment_url = attachments[attachment_title].url
      image_tag(attachment_url).html_safe
    end
  end
end
