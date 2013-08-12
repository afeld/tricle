require_relative 'group'

# internal representation of the data displayed in the Mailer
module Tricle
  class Report
    attr_reader :groups

    def initialize
      @groups = []
    end

    def add_group(title=nil)
      self.groups << Tricle::Group.new(title)
    end

    def add_metric(klass)
      self.add_group if self.groups.empty?
      # TODO don't assume they want to add this metric to the last group?
      self.groups.last.add_metric(klass)
    end
  end
end
