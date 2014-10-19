require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'

module Tricle
  module EmailHelper
    include ActiveSupport::Inflector

    def num_durations
      case period
      when :day
        7 # week
      when :week
        13 # quarter
      when :month
        12 # year
      end
    end

    def periods_ago(n)
      case period
      when :day
        Date.today.beginning_of_day.advance(days: -n)
      when :week
        Date.today.beginning_of_week.ago(n.weeks)
      when :month
        Date.today.beginning_of_month.advance(months: -n)
      end
    end

    def end_of_period(beginning)
      case period
      when :day
        beginning.end_of_day
      when :week
        beginning.end_of_week
      when :month
        beginning.end_of_month
      end
    end

    def add_periods(time, n)
      case period
      when :day
        time + n.days
      when :week
        time + n.weeks
      when :month
        time + n.months
      end
    end

    def format_date(date)
      date.strftime('%-m/%-d/%y')
    end

    def format_number(number, unit = nil)
      number_with_delimiter(if number.abs >= 100 then number.round else sig_figs(number) end) +
      (if unit then ' ' + unit.pluralize(number.abs) else '' end)
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

    def percent_change_class(new_val, old_val, better)
      case better
      when :higher
        (new_val >= old_val) ? 'good' : 'bad'
      when :lower
        (new_val > old_val) ? 'bad' : 'good'
      else
        ''
      end
    end

    def percent_change_cell(new_val, old_val, better, unit)
      cls = self.percent_change_class(new_val, old_val, better)
      pct_str = percent_change(new_val, old_val)
      old_val_str = format_number(old_val, unit)
      %[<td class="#{cls}"><div>#{pct_str}</div><div>#{old_val_str}</div></td>].html_safe
    end

    def dates_range_str(start_at, end_at)
      if end_at
        "#{ self.format_date(start_at) } - #{ self.format_date(end_at) }"
      else
        self.format_date(start_at)
      end
    end

    def dates_cell(start_at, end_at)
      range = dates_range_str(start_at, end_at)
      %[<div class="date-range">(#{range})</div>].html_safe
    end

    def single_day_dates_cell(start_at)
      dates_cell(start_at, nil)
    end

    def single_week_dates_cell(start_at)
      dates_cell(start_at, start_at.end_of_week)
    end

    def single_month_dates_cell(start_at)
      dates_cell(start_at, start_at.end_of_month)
    end

    def period
      self.mailer.period
    end

    def old_dates_cell
      dates_cell periods_ago(num_durations), end_of_period(periods_ago(1))
    end

    def previous_dates_cell
      dates_cell(
        periods_ago(2),
        if period == :day then nil else end_of_period(periods_ago(2)) end
      )
    end

    def current_dates_cell
      dates_cell(
        periods_ago(1),
        if period == :day then nil else end_of_period(periods_ago(1)) end
      )
    end

    def old_dates_cell_header
      case period
      when :day
        'Weekly average'
      when :week
        'Quarterly average'
      when :month
        'Yearly average'
      end
    end

    def previous_dates_cell_header
      case period
      when :day
        '2 days ago'
      when :week
        'Previous week'
      when :month
        'Previous month'
      end
    end

    def current_dates_cell_header
      case period
      when :day
        'Yesterday'
      when :week
        'Last week'
      when :month
        'Last month'
      end
    end

    def old_data_cell(metric)
      percent_change_cell metric.periods_ago(period, 1),
                          metric.range_average(period, num_durations),
                          metric.better,
                          metric.unit
    end

    def previous_data_cell(metric)
      percent_change_cell metric.periods_ago(period, 1),
                          metric.periods_ago(period, 2),
                          metric.better,
                          metric.unit
    end

    def current_number(metric)
      format_number metric.periods_ago(period, 1),
                    metric.unit
    end

    def list_markup(list)
      start_at = self.periods_ago(1).to_time
      end_at = add_periods(start_at, 1)
      list.items_markup(start_at, end_at).html_safe
    end

    def sparkline(metric)
      values = metric.range_values(period, num_durations)
      attachment_url = "https://sparklines.herokuapp.com/api/v1.png?values=#{values.join(',')}"
      image_tag(attachment_url, alt: 'sparkline').html_safe
    end
  end
end
