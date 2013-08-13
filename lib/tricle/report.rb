require_relative 'group'
require_relative 'list'

# internal representation of the data displayed in the Mailer
module Tricle
  class Report
    attr_reader :sections

    def initialize
      @sections = []
    end

    def add_section(section)
      self.sections << section
      section
    end

    def add_group(title=nil)
      group = Tricle::Group.new(title)
      self.add_section(group)
    end

    def add_metric(klass)
      last_section = self.sections.last
      unless last_section.is_a?(Tricle::Group)
        last_section = self.add_group
      end

      # TODO don't assume they want to add this metric to the last group?
      last_section.add_metric(klass)
    end

    def add_list(klass)
      list = Tricle::List.new(klass)
      self.add_section(list)
    end
  end
end
