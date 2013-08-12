# internal representation of the data displayed in the Mailer
module Tricle
  class Report
    attr_reader :metric_instances

    def initialize
      @metric_instances = []
    end

    def add_metric(klass)
      self.metric_instances << klass.new
    end
  end
end
