require_relative '../group'
require_relative '../list'

# internal representation of the data displayed in the Mailer
module Tricle
  module Presenters
    module Report
      class Base
        attr_reader :now, :sections

        def initialize
          # freeze the current time so it's consistent across metrics
          @now = Time.now
          @sections = []
        end

        def add_section(section)
          self.sections << section
          section
        end

        def add_group(title=nil)
          group = Tricle::Presenters::Group.new(self.now, title)
          self.add_section(group)
        end

        def add_metric(klass)
          last_section = self.sections.last
          unless last_section.is_a?(Tricle::Presenters::Group)
            last_section = self.add_group
          end

          # TODO don't assume they want to add this metric to the last group?
          last_section.add_metric(klass)
        end

        def add_list(klass, &block)
          list = Tricle::List.new(klass, &block)
          self.add_section(list)
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
      end
    end
  end
end
