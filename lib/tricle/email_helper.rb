require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'

module Tricle
  module EmailHelper
    include ActiveSupport::Inflector

    def days_ago(n)
      Date.today.beginning_of_day.advance(days: -n)
    end

    def weeks_ago(n)
      Date.today.beginning_of_week.ago(n.weeks)
    end

    def months_ago(n)
      Date.today.beginning_of_month.advance(months: -n)
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
      case period
      when :day
        dates_cell(days_ago(7), days_ago(1).end_of_day)
      when :week
        dates_cell(weeks_ago(13), weeks_ago(1).end_of_week)
      when :month
        dates_cell(months_ago(12), months_ago(1).end_of_month)
      end
    end

    def previous_dates_cell
      case period
      when :day
        single_day_dates_cell(days_ago(2))
      when :week
        single_week_dates_cell(weeks_ago(2))
      when :month
        single_month_dates_cell(months_ago(2))
      end
    end

    def current_dates_cell
      case period
      when :day
        single_day_dates_cell(days_ago(1))
      when :week
        single_week_dates_cell(weeks_ago(1))
      when :month
        single_month_dates_cell(months_ago(1))
      end
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
      case period
      when :day
        percent_change_cell(metric.yesterday, metric.day_average_this_week, metric.better, metric.unit)
      when :week
        percent_change_cell(metric.last_week, metric.week_average_this_quarter, metric.better, metric.unit)
      when :month
        percent_change_cell(metric.last_month, metric.month_average_this_year, metric.better, metric.unit)
      end
    end

    def previous_data_cell(metric)
      case period
      when :day
        percent_change_cell(metric.yesterday, metric.days_ago(2), metric.better, metric.unit)
      when :week
        percent_change_cell(metric.last_week, metric.weeks_ago(2), metric.better, metric.unit)
      when :month
        percent_change_cell(metric.last_month, metric.months_ago(2), metric.better, metric.unit)
      end
    end

    def current_number(metric)
      case period
      when :day
        format_number(metric.yesterday, metric.unit)
      when :week
        format_number(metric.last_week, metric.unit)
      when :month
        format_number(metric.last_month, metric.unit)
      end
    end

    def list_markup(list)
      case period
      when :day
        start_at = self.days_ago(1).to_time
        end_at = start_at + 1.day
      when :week
        start_at = self.weeks_ago(1).to_time
        end_at = start_at + 7.days
      when :month
        start_at = self.months_ago(1).to_time
        end_at = start_at + 1.month
      end

      list.items_markup(start_at, end_at).html_safe
    end

    def sparkline(metric)
      values = case period
      when :day
        metric.daily_values(7)
      when :week
        metric.weekly_values(13)
      when :month
        metric.monthly_values(12)
      end

      attachment_url = "https://sparklines.herokuapp.com/api/v1.png?values=#{values.join(',')}"
      image_tag(attachment_url, alt: 'sparkline').html_safe
    end
  end
end
