require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'

module Tricle
  module EmailHelper
    def weeks_ago(n)
      Date.today.beginning_of_week.weeks_ago(n)
    end

    def format_date(date)
      date.strftime('%-m/%-d/%y')
    end

    def format_number(number)
      number_with_delimiter((number.abs >= 100 ? number.round : sig_figs(number)))
    end

    def number_with_delimiter(number)
      # from http://stackoverflow.com/a/11466770/358804
      integer, decimal = number.to_s.split(".")
      [integer.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse, decimal].compact.join('.')
    end

    def sig_figs(number, num_sig_figs = 3)
      # http://six-impossible.blogspot.com/2011/05/significant-digits-in-ruby-float.html
      f = sprintf("%.#{num_sig_figs - 1}e", number).to_f
      i = f.to_i # avoid
      i == f && i.to_s.size > num_sig_figs ? i : f
    end

    def percent_change(new_val, old_val)
      if old_val == new_val
        'No change'
      elsif old_val == 0
        new_val >= 0 ? '+' : '-'
      else
        fraction = (new_val - old_val) / old_val.to_f
        (fraction >= 0 ? '+' : '').concat("#{sig_figs(fraction * 100.0)}%")
      end
    end

    def percent_change_cell(new_val, old_val)
      cls = (new_val >= old_val) ? 'positive' : 'negative'
      pct_str = percent_change(new_val, old_val)
      old_val_str = format_number(old_val)
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
  end
end
