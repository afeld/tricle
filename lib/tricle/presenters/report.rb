require_relative 'group'
require_relative 'list'

# internal representation of the data displayed in the Mailer
module Tricle
  module Presenters
    class Report
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
    end
  end
end
